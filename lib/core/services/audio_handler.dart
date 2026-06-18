import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class MusicAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
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
    _player.currentIndexStream.listen(_onCurrentIndexChanged);
    _player.sequenceStateStream.listen(_onSequenceChanged);
  }

  void _onPlayerStateChanged(PlayerState state) {
    playbackState.add(PlaybackState(
      playing: state.playing,
      processingState: _convertProcessingState(state.processingState),
      controls: [
        MediaControl.skipToPrevious,
        if (state.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: {MediaAction.seek},
    ));
  }

  void _onCurrentIndexChanged(int? index) {
    if (index != null && index < _queue.length) {
      mediaItem.add(_queue[index]);
    }
  }

  void _onSequenceChanged(SequenceState? sequence) {
    if (sequence == null) return;
    final index = sequence.currentIndex;
    if (index != null && index < _queue.length) {
      mediaItem.add(_queue[index]);
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
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _queue.length) return;
    await _player.seek(Duration.zero, index: index);
    mediaItem.add(_queue[index]);
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

  Future<void> setQueue(List<MediaItem> items, {int? initialIndex}) async {
    _queue = List.from(items);
    queue.add(_queue);

    final sources = items
        .map((item) => AudioSource.uri(Uri.parse(item.id)))
        .toList();

    await _player.setAudioSources(
      sources,
      initialIndex: initialIndex ?? 0,
    );

    if (initialIndex != null && initialIndex < items.length) {
      mediaItem.add(items[initialIndex]);
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
    _queue.remove(mediaItem);
    queue.add(_queue);
    final sources = _queue
        .map((item) => AudioSource.uri(Uri.parse(item.id)))
        .toList();
    await _player.setAudioSources(sources);
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    if (index < 0 || index >= _queue.length) return;
    _queue.removeAt(index);
    queue.add(_queue);
    final sources = _queue
        .map((item) => AudioSource.uri(Uri.parse(item.id)))
        .toList();
    await _player.setAudioSources(sources);
  }

  Future<void> clearQueue() async {
    _queue = [];
    queue.add(_queue);
    await _player.setAudioSources([]);
    mediaItem.add(null);
  }

  List<MediaItem> get currentQueue => List.unmodifiable(_queue);

  @override
  Future<void> onTaskRemoved() async {
    await stop();
    await super.onTaskRemoved();
  }

  Future<void> dispose() => _player.dispose();
}
