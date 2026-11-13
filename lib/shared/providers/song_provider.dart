import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../models/song.dart';
import '../repositories/repository_providers.dart';
import 'audio_query_provider.dart';
import 'isar_provider.dart';

final songsProvider =
    AsyncNotifierProvider<SongsNotifier, List<Song>>(SongsNotifier.new);

class SongsNotifier extends AsyncNotifier<List<Song>> {
  @override
  Future<List<Song>> build() async {
    final repo = await ref.watch(songRepositoryProvider.future);
    return repo.getAll();
  }

  Future<void> refresh() async {
    final repo = await ref.read(songRepositoryProvider.future);
    state = const AsyncLoading();
    state = AsyncData(await repo.getAll(forceRefresh: true));
  }
}

final albumsProvider = Provider<AsyncValue<Map<String, List<Song>>>>((ref) {
  final songsAsync = ref.watch(songsProvider);
  return songsAsync.whenData((songs) {
    final map = <String, List<Song>>{};
    for (final song in songs) {
      final key = song.albumName ?? 'Unknown Album';
      map.putIfAbsent(key, () => []).add(song);
    }
    return map;
  });
});

final artistsProvider = Provider<AsyncValue<Map<String, List<Song>>>>((ref) {
  final songsAsync = ref.watch(songsProvider);
  return songsAsync.whenData((songs) {
    final map = <String, List<Song>>{};
    for (final song in songs) {
      final key = song.artistName ?? 'Unknown Artist';
      map.putIfAbsent(key, () => []).add(song);
    }
    return map;
  });
});

final foldersProvider = Provider<AsyncValue<Map<String, List<Song>>>>((ref) {
  final songsAsync = ref.watch(songsProvider);
  return songsAsync.whenData((songs) {
    final map = <String, List<Song>>{};
    for (final song in songs) {
      final folder = _extractFolder(song.uri);
      if (folder != null) {
        map.putIfAbsent(folder, () => []).add(song);
      }
    }
    return map;
  });
});

String? _extractFolder(String? uri) {
  if (uri == null || uri.isEmpty) return null;
  try {
    final segments = Uri.parse(uri).pathSegments;
    if (segments.length >= 2) {
      return segments[segments.length - 2];
    }
    return '/';
  } catch (_) {
    return null;
  }
}

final songByIdProvider = FutureProvider.family<Song?, int>((ref, songId) async {
  final isar = await ref.watch(isarProvider.future);
  return isar.songs.get(songId);
});

final artworkProvider =
    FutureProvider.family<Uint8List?, int>((ref, audioId) async {
  final audioQuery = ref.watch(audioQueryProvider);
  return audioQuery.queryArtwork(audioId, ArtworkType.AUDIO, size: 300);
});

final artworkCacheProvider =
    NotifierProvider<ArtworkCacheNotifier, HashMap<int, Uint8List?>>(
  ArtworkCacheNotifier.new,
);

class ArtworkCacheNotifier extends Notifier<HashMap<int, Uint8List?>> {
  @override
  HashMap<int, Uint8List?> build() => HashMap<int, Uint8List?>();

  void cache(int audioId, Uint8List? bytes) {
    state[audioId] = bytes;
  }

  Uint8List? get(int audioId) => state[audioId];
}
