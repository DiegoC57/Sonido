import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/audio_handler.dart';
import '../models/song.dart';

final audioHandlerProvider = FutureProvider<MusicAudioHandler>((ref) async {
  final handler = MusicAudioHandler();
  try {
    await AudioService.init(
      builder: () => handler,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.sonido.sonido.channel',
        androidNotificationChannelName: 'Sonido',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        androidNotificationClickStartsActivity: true,
      ),
    );
  } catch (e) {
    ref.onDispose(() => handler.dispose());
    rethrow;
  }
  ref.onDispose(() => handler.dispose());
  return handler;
});

final _handlerValue = Provider<MusicAudioHandler?>((ref) {
  return ref.watch(audioHandlerProvider).asData?.value;
});

final currentMediaItemProvider = StreamProvider<MediaItem?>((ref) {
  final handler = ref.watch(_handlerValue);
  if (handler == null) return Stream.value(null);
  return handler.mediaItem.stream;
});

final playerStateProvider = StreamProvider<PlaybackState>((ref) {
  final handler = ref.watch(_handlerValue);
  if (handler == null) return const Stream.empty();
  return handler.playbackState.stream;
});

final isPlayingProvider = Provider<bool>((ref) {
  final state = ref.watch(playerStateProvider).asData?.value;
  return state?.playing ?? false;
});

final positionProvider = StreamProvider<Duration>((ref) {
  final handler = ref.watch(_handlerValue);
  if (handler == null) return const Stream.empty();
  return handler.player.positionStream;
});

final durationProvider = StreamProvider<Duration?>((ref) {
  final handler = ref.watch(_handlerValue);
  if (handler == null) return const Stream.empty();
  return handler.player.durationStream;
});

final shuffleModeProvider = StreamProvider<AudioServiceShuffleMode>((ref) {
  final handler = ref.watch(_handlerValue);
  if (handler == null) return Stream.value(AudioServiceShuffleMode.none);
  return handler.shuffleMode;
});

final repeatModeProvider = StreamProvider<AudioServiceRepeatMode>((ref) {
  final handler = ref.watch(_handlerValue);
  if (handler == null) return Stream.value(AudioServiceRepeatMode.none);
  return handler.repeatMode;
});

final queueProvider = StreamProvider<List<MediaItem>>((ref) {
  final handler = ref.watch(_handlerValue);
  if (handler == null) return const Stream.empty();
  return handler.queue.stream;
});

extension SongToMediaItem on Song {
  MediaItem toMediaItem() {
    return MediaItem(
      id: uri ?? '',
      title: title,
      artist: artistName,
      album: albumName,
      duration: Duration(milliseconds: duration ?? 0),
      artUri: null,
      extras: {
        'audioId': audioId,
        'albumId': albumId,
      },
    );
  }
}

final playerActionsProvider = Provider<PlayerActions>((ref) {
  return PlayerActions(ref);
});

class PlayerActions {
  final Ref _ref;

  PlayerActions(this._ref);

  Future<void> play(Song song) async {
    final handler = await _ref.read(audioHandlerProvider.future);
    await handler.setQueue([song.toMediaItem()], initialIndex: 0);
    await handler.play();
  }

  Future<void> playFromList(List<Song> songs, {int index = 0}) async {
    if (songs.isEmpty) return;
    final handler = await _ref.read(audioHandlerProvider.future);
    final items = songs.map((s) => s.toMediaItem()).toList();
    await handler.setQueue(items, initialIndex: index);
    await handler.play();
  }

  Future<void> playNext(Song song) async {
    final handler = await _ref.read(audioHandlerProvider.future);
    final index = handler.player.currentIndex ?? 0;
    await handler.insertQueueItem(index + 1, song.toMediaItem());
  }

  Future<void> addToQueue(Song song) async {
    final handler = await _ref.read(audioHandlerProvider.future);
    await handler.addQueueItem(song.toMediaItem());
  }

  Future<void> togglePlayPause() async {
    final handler = await _ref.read(audioHandlerProvider.future);
    if (handler.playbackState.value.playing) {
      await handler.pause();
    } else {
      await handler.play();
    }
  }

  Future<void> seek(Duration position) async {
    final handler = await _ref.read(audioHandlerProvider.future);
    await handler.seek(position);
  }

  Future<void> skipToNext() async {
    final handler = await _ref.read(audioHandlerProvider.future);
    await handler.skipToNext();
  }

  Future<void> skipToPrevious() async {
    final handler = await _ref.read(audioHandlerProvider.future);
    await handler.skipToPrevious();
  }

  Future<void> toggleShuffle() async {
    final handler = await _ref.read(audioHandlerProvider.future);
    final current = handler.shuffleMode.value;
    await handler.setShuffleMode(
      current == AudioServiceShuffleMode.all
          ? AudioServiceShuffleMode.none
          : AudioServiceShuffleMode.all,
    );
  }

  Future<void> cycleRepeatMode() async {
    final handler = await _ref.read(audioHandlerProvider.future);
    final current = handler.repeatMode.value;
    switch (current) {
      case AudioServiceRepeatMode.none:
        await handler.setRepeatMode(AudioServiceRepeatMode.all);
      case AudioServiceRepeatMode.all:
        await handler.setRepeatMode(AudioServiceRepeatMode.one);
      case AudioServiceRepeatMode.one:
        await handler.setRepeatMode(AudioServiceRepeatMode.none);
      case AudioServiceRepeatMode.group:
        await handler.setRepeatMode(AudioServiceRepeatMode.none);
    }
  }
}
