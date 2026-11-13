import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/player_provider.dart';
import '../../../shared/providers/song_provider.dart';
import '../../../shared/widgets/artwork.dart';
import '../../../shared/widgets/onda_widgets.dart';

class ArtistsTab extends ConsumerWidget {
  const ArtistsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistsAsync = ref.watch(artistsProvider);
    final bottomPad = shellBottomPadding(context, ref);

    return artistsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EmptyState('Error: $e'),
      data: (artists) {
        final entries = artists.entries.toList()
          ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));
        if (entries.isEmpty) {
          return const EmptyState('No se encontraron artistas');
        }
        return ListView.builder(
          padding: EdgeInsets.only(bottom: bottomPad),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final albums = entry.value
                .map((s) => s.albumName)
                .whereType<String>()
                .toSet()
                .length;
            final albumWord = albums == 1 ? 'álbum' : 'álbumes';
            return MediaRow(
              leading: Artwork(
                audioId: entry.value.first.audioId,
                seed: entry.key,
                size: 56,
                radius: 28,
              ),
              title: entry.key == 'Unknown Artist'
                  ? 'Artista desconocido'
                  : entry.key,
              subtitle:
                  'Artista · ${entry.value.length} canciones · $albums $albumWord',
              onTap: () =>
                  ref.read(playerActionsProvider).playFromList(entry.value),
            );
          },
        );
      },
    );
  }
}
