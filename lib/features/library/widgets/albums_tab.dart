import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/song_provider.dart';

class AlbumsTab extends ConsumerWidget {
  const AlbumsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(albumsProvider);

    return albumsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (albums) {
        final entries = albums.entries.toList()
          ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.album, size: 72, color: Colors.grey.shade600),
                const SizedBox(height: 16),
                Text('No se encontraron álbumes',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 18)),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final firstSong = entry.value.first;
            final duration = entry.value.fold<int>(
                0, (sum, s) => sum + (s.duration ?? 0));

            return _AlbumCard(
              name: entry.key,
              artistName: firstSong.artistName ?? 'Unknown Artist',
              songCount: entry.value.length,
              duration: duration,
              audioId: firstSong.audioId,
            );
          },
        );
      },
    );
  }
}

class _AlbumCard extends ConsumerWidget {
  final String name;
  final String artistName;
  final int songCount;
  final int duration;
  final int? audioId;

  const _AlbumCard({
    required this.name,
    required this.artistName,
    required this.songCount,
    required this.duration,
    this.audioId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkAsync = audioId != null
        ? ref.watch(artworkProvider(audioId!))
        : null;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: artworkAsync?.when(
                    loading: () => _placeholder(),
                    error: (_, _) => _placeholder(),
                    data: (bytes) {
                      if (bytes == null) return _placeholder();
                      return Image.memory(bytes, fit: BoxFit.cover);
                    },
                  ) ??
                  _placeholder(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: Text(
                '$artistName · $songCount canciones',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade800,
      child: Center(
        child: Icon(Icons.album, size: 48, color: Colors.grey.shade600),
      ),
    );
  }
}
