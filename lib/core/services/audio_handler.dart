import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class MusicAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final BehaviorSubject<AudioServiceShuffleMode> _shuffleMode =
      BehaviorSubject.seeded(AudioServiceShuffleMode.none);
  final BehaviorSubject<AudioServiceRepeatMode> _repeatMode =
      BehaviorSubject.seeded(AudioServiceRepeatMode.none);
  List<MediaItem> _queue = [];

  AudioPlayer get player => _player;
  ValueStream<AudioServiceShuffleMode> get shuffleMode => _shuffleMode;
  ValueStream<AudioServiceRepeatMode> get repeatMode => _repeatMode;

  MusicAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    await _player.setAudioSources([]);

    _player.playerStateStream.listen(_onPlayerStateChanged);
    // playbackEventStream fires on every position discontinuity: seeks,
    // processing-state changes and — crucially — auto-advancing to the next
    // track. Without it, an auto-advance (playing stays true) never
    // re-broadcast updatePosition, so the notification kept extrapolating
    // from the previous track's last position and its seek bar stuck at
    // the end.
    _player.playbackEventStream.listen(
      (_) => _broadcastPlaybackState(),
      onError: (Object e, StackTrace st) {},
    );
    _player.currentIndexStream.listen(_onCurrentIndexChanged);
    _player.durationStream.listen(_onDurationChanged);
  }

  void _onPlayerStateChanged(PlayerState state) {
    _broadcastPlaybackState(playing: state.playing);
  }

  /// Keeps the notification's total duration in sync with the real decoded
  /// duration (the stored metadata can be missing or slightly off).
  void _onDurationChanged(Duration? duration) {
    final current = mediaItem.value;
    if (duration == null || current == null) return;
    if (current.duration == duration) return;
    mediaItem.add(current.copyWith(duration: duration));
  }

  /// Broadcasts the current playback state to the system notification and
  /// lock screen. Crucially includes [updatePosition]/[bufferedPosition]:
  /// without them, PlaybackState.position defaults to zero, which is why
  /// the notification's timeline used to snap back to the start on every
  /// pause and right after every seek.
  void _broadcastPlaybackState({bool? playing}) {
    playbackState.add(PlaybackState(
      playing: playing ?? _player.playing,
      processingState: _convertProcessingState(_player.processingState),
      controls: [
        MediaControl.skipToPrevious,
        if (playing ?? _player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: {MediaAction.seek},
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    ));
  }

  void _onCurrentIndexChanged(int? index) {
    if (index != null && index < _queue.length) {
      final item = _queue[index];
      mediaItem.add(item);
      _attachArtworkIfNeeded(item);
    }
  }

  /// Lazily resolves and caches the artwork for [item] so the system
  /// notification and lock screen show real cover art. Only ever fetches
  /// artwork for whichever track is actually current, and reuses a cached
  /// file on repeat plays instead of re-querying the OS content resolver.
  Future<void> _attachArtworkIfNeeded(MediaItem item) async {
    if (item.artUri != null) return;
    final audioId = item.extras?['audioId'] as int?;
    if (audioId == null) return;
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/sonido_artwork_$audioId.jpg');
      Uri artUri;
      if (await file.exists()) {
        artUri = file.uri;
      } else {
        final bytes = await _audioQuery.queryArtwork(
          audioId,
          ArtworkType.AUDIO,
          size: 512,
        );
        if (bytes == null || bytes.isEmpty) return;
        await file.writeAsBytes(bytes, flush: true);
        artUri = file.uri;
      }
      // Only apply if this item is still the current one (avoid a stale
      // update landing after the user has already skipped ahead).
      final current = mediaItem.value;
      if (current?.id == item.id) {
        mediaItem.add(current!.copyWith(artUri: artUri));
      }
    } catch (_) {
      // Artwork is best-effort; playback must never be affected by this.
    }
  }

  AudioProcessingState _convertProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
    playbackState.add(PlaybackState(
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
    _broadcastPlaybackState();
  }

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _queue.length) return;
    await _player.seek(Duration.zero, index: index);
    mediaItem.add(_queue[index]);
    _broadcastPlaybackState();
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    await _player.setShuffleModeEnabled(
        shuffleMode == AudioServiceShuffleMode.all);
    _shuffleMode.add(shuffleMode);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        await _player.setLoopMode(LoopMode.off);
      case AudioServiceRepeatMode.one:
        await _player.setLoopMode(LoopMode.one);
      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        await _player.setLoopMode(LoopMode.all);
    }
    _repeatMode.add(repeatMode);
  }

  Future<void> setQueue(
    List<MediaItem> items, {
    int? initialIndex,
    Duration? initialPosition,
  }) async {
    _queue = List.from(items);
    queue.add(_queue);

    final sources = items
        .map((item) => AudioSource.uri(Uri.parse(item.id)))
        .toList();

    await _player.setAudioSources(
      sources,
      initialIndex: initialIndex ?? 0,
      initialPosition: initialPosition,
    );

    if (initialIndex != null && initialIndex < items.length) {
      final item = items[initialIndex];
      mediaItem.add(item);
      _attachArtworkIfNeeded(item);
    }
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    _queue.add(mediaItem);
    queue.add(_queue);
    await _player.addAudioSource(AudioSource.uri(Uri.parse(mediaItem.id)));
  }

  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) async {
    if (index < 0 || index > _queue.length) return;
    _queue.insert(index, mediaItem);
    queue.add(_queue);
    await _player.insertAudioSource(
        index, AudioSource.uri(Uri.parse(mediaItem.id)));
  }

  @override
  Future<void> removeQueueItem(MediaItem mediaItem) async {
    final index = _queue.indexOf(mediaItem);
    if (index < 0) return;
    await removeQueueItemAt(index);
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    if (index < 0 || index >= _queue.length) return;
    _queue.removeAt(index);
    queue.add(_queue);
    // Remove in place so the current track keeps playing.
    await _player.removeAudioSourceAt(index);
  }

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;
    final item = _queue.removeAt(oldIndex);
    _queue.insert(newIndex, item);
    queue.add(_queue);
    // Move in place: no stop/reload, so playback isn't interrupted.
    await _player.moveAudioSource(oldIndex, newIndex);
  }

  Future<void> clearQueue() async {
    _queue = [];
    queue.add(_queue);
    await _player.setAudioSources([]);
    mediaItem.add(null);
  }

  List<MediaItem> get currentQueue => List.unmodifiable(_queue);

  /// Index (into [currentQueue]) of the track that is currently loaded.
  int? get currentQueueIndex => _player.currentIndex;

  @override
  Future<void> onTaskRemoved() async {
    await stop();
    await super.onTaskRemoved();
  }

  Future<void> dispose() => _player.dispose();
}
