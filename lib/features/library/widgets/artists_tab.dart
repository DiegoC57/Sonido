import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/main_shell.dart';
import '../../../shared/providers/player_provider.dart';
import '../../../shared/providers/song_provider.dart';
import '../../../shared/theme/app_text_styles.dart';

class ArtistsTab extends ConsumerWidget {
  const ArtistsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistsAsync = ref.watch(artistsProvider);
    final hasMedia = ref.watch(hasMediaProvider).asData?.value ?? false;
    final bottomPad = MediaQuery.of(context).padding.bottom +
        kBottomNavHeight +
        (hasMedia ? kMiniPlayerHeight : 0);

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
          padding: EdgeInsets.fromLTRB(0, 4, 0, bottomPad),
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
                style: appListTitle(),
              ),
              subtitle: Text(
                '${entry.value.length} canciones · $albums álbumes',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: appSecondary(fontSize: 13, color: Colors.grey.shade500),
              ),
              onTap: () {
                ref.read(playerActionsProvider).playFromList(entry.value);
              },
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
