import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/main_shell.dart';
import '../../shared/models/playlist.dart';
import '../../shared/models/song.dart';
import '../../shared/providers/isar_provider.dart';
import '../../shared/providers/player_provider.dart';
import '../../shared/repositories/repository_providers.dart';
import '../../shared/widgets/song_tile.dart';

final _playlistProvider = FutureProvider.family<Playlist?, int>((ref, id) async {
  final repo = await ref.watch(playlistRepositoryProvider.future);
  return repo.getById(id);
});

final _playlistSongsProvider = FutureProvider.family<List<Song>, int>((ref, id) async {
  final playlist = await ref.watch(_playlistProvider(id).future);
  if (playlist == null || playlist.songIds == null || playlist.songIds!.isEmpty) {
    return [];
  }
  final isar = await ref.watch(isarProvider.future);
  final songs = <Song>[];
  for (final songId in playlist.songIds!) {
    final song = await isar.songs.get(songId);
    if (song != null) songs.add(song);
  }
  return songs;
});

class PlaylistDetailScreen extends ConsumerWidget {
  final int playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistAsync = ref.watch(_playlistProvider(playlistId));
    final songsAsync = ref.watch(_playlistSongsProvider(playlistId));

    return ScreenWithMiniPlayer(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(playlistAsync.asData?.value?.name ?? 'Playlist'),
        ),
        body: songsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (songs) {
            if (songs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.playlist_play, size: 72, color: Colors.grey.shade600),
                    const SizedBox(height: 16),
                    Text(
                      'Todavía no hay canciones en esta playlist',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return SongTile(
                  song: song,
                  onTap: () {
                    ref.read(playerActionsProvider).playFromList(songs, index: index);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
