import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/main_shell.dart';
import '../../../shared/models/song.dart';
import '../../../shared/providers/player_provider.dart';
import '../../../shared/providers/song_provider.dart';
import '../../../shared/theme/app_text_styles.dart';

class AlbumsTab extends ConsumerWidget {
  const AlbumsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(albumsProvider);
    final hasMedia = ref.watch(hasMediaProvider).asData?.value ?? false;
    final bottomPad = MediaQuery.of(context).padding.bottom +
        kBottomNavHeight +
        (hasMedia ? kMiniPlayerHeight : 0);

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
          padding: EdgeInsets.fromLTRB(12, 12, 12, bottomPad),
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
              songs: entry.value,
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
  final List<Song> songs;

  const _AlbumCard({
    required this.name,
    required this.artistName,
    required this.songCount,
    required this.duration,
    required this.songs,
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
        onTap: () {
          ref.read(playerActionsProvider).playFromList(songs);
        },
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
                style: appListTitle().copyWith(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: Text(
                '$artistName · $songCount canciones',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: appSecondary(fontSize: 12, color: Colors.grey.shade500),
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
