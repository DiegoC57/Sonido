import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/song_provider.dart';

class ArtistsTab extends ConsumerWidget {
  const ArtistsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistsAsync = ref.watch(artistsProvider);

    return artistsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (artists) {
        final entries = artists.entries.toList()
          ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 72, color: Colors.grey.shade600),
                const SizedBox(height: 16),
                Text('No se encontraron artistas',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 18)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final albums = entry.value
                .map((s) => s.albumName)
                .whereType<String>()
                .toSet()
                .length;
            final firstSong = entry.value.first;

            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade800,
                child: firstSong.audioId != null
                    ? _ArtistArtwork(audioId: firstSong.audioId!)
                    : Icon(Icons.person, color: Colors.grey.shade500),
              ),
              title: Text(
                entry.key,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                '${entry.value.length} canciones · $albums álbumes',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              onTap: () {},
            );
          },
        );
      },
    );
  }
}

class _ArtistArtwork extends ConsumerWidget {
  final int audioId;

  const _ArtistArtwork({required this.audioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkAsync = ref.watch(artworkProvider(audioId));
    return artworkAsync.when(
      loading: () => Icon(Icons.person, color: Colors.grey.shade500),
      error: (_, _) => Icon(Icons.person, color: Colors.grey.shade500),
      data: (bytes) {
        if (bytes == null) return Icon(Icons.person, color: Colors.grey.shade500);
        return ClipOval(
          child: Image.memory(bytes, fit: BoxFit.cover, width: 48, height: 48),
        );
      },
    );
  }
}
