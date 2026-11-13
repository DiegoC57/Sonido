import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/playlist.dart';
import '../models/song.dart';
import '../repositories/repository_providers.dart';
import 'isar_provider.dart';

/// All playlists. Invalidate after creating a playlist or changing its songs.
final playlistsProvider = FutureProvider<List<Playlist>>((ref) async {
  final repo = await ref.watch(playlistRepositoryProvider.future);
  return repo.getAll();
});

/// One playlist. Auto-disposed so reopening the screen always shows fresh data.
final playlistByIdProvider =
    FutureProvider.autoDispose.family<Playlist?, int>((ref, id) async {
  final repo = await ref.watch(playlistRepositoryProvider.future);
  return repo.getById(id);
});

final playlistSongsProvider =
    FutureProvider.autoDispose.family<List<Song>, int>((ref, id) async {
  final playlist = await ref.watch(playlistByIdProvider(id).future);
  final ids = playlist?.songIds;
  if (ids == null || ids.isEmpty) return [];
  final isar = await ref.watch(isarProvider.future);
  final songs = await isar.songs.getAll(ids);
  return songs.whereType<Song>().toList();
});

/// Call after any playlist mutation so every list showing playlists refreshes.
void refreshPlaylists(WidgetRef ref, [int? playlistId]) {
  ref.invalidate(playlistsProvider);
  if (playlistId != null) ref.invalidate(playlistByIdProvider(playlistId));
}
