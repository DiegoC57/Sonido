import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/song.dart';
import '../../../shared/providers/song_provider.dart';
import '../../../shared/providers/player_provider.dart';
import '../../../shared/widgets/song_tile.dart';

class SongsTab extends ConsumerStatefulWidget {
  const SongsTab({super.key});

  @override
  ConsumerState<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends ConsumerState<SongsTab> {
  void _playSong(List<Song> songs, int index) {
    final actions = ref.read(playerActionsProvider);
    actions.playFromList(songs, index: index);
    if (!mounted) return;
    final currentRoute = GoRouterState.of(context).uri.toString();
    if (currentRoute != '/player') {
      context.push('/player');
    }
  }

  void _playNext(Song song) async {
    final actions = ref.read(playerActionsProvider);
    await actions.playNext(song);
  }

  void _addToQueue(Song song) async {
    final actions = ref.read(playerActionsProvider);
    await actions.addToQueue(song);
  }

  @override
  Widget build(BuildContext context) {
    final songsAsync = ref.watch(songsProvider);

    return songsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text('Error al cargar canciones: $e',
              textAlign: TextAlign.center),
        ),
      ),
      data: (songs) {
        if (songs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.music_note, size: 72, color: Colors.grey.shade600),
                const SizedBox(height: 16),
                Text(
                  'No se encontraron canciones',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => ref.read(songsProvider.notifier).refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Escanear biblioteca'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(songsProvider.notifier).refresh(),
          displacement: 40,
          color: Colors.white,
          backgroundColor: Colors.grey.shade800,
          child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return SongTile(
                song: song,
                onTap: () => _playSong(songs, index),
                onPlayNext: () => _playNext(song),
                onAddToQueue: () => _addToQueue(song),
              );
            },
          ),
        );
      },
    );
  }
}
