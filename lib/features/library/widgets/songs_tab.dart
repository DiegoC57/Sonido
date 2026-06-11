import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/song.dart';
import '../../../shared/providers/song_provider.dart';
import '../../../shared/widgets/song_tile.dart';

class SongsTab extends ConsumerWidget {
  const SongsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

        return Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${songs.length} canciones',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 32,
                    child: TextButton.icon(
                      onPressed: () =>
                          ref.read(songsProvider.notifier).refresh(),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Actualizar', style: TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemExtent: 64,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return SongTile(
                    song: song,
                    onTap: () => _playSong(context, song),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _playSong(BuildContext context, Song song) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reproduciendo: ${song.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
