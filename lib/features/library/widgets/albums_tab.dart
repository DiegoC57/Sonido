import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router.dart' show openAlbum;
import '../../../shared/providers/song_provider.dart';
import '../../../shared/widgets/artwork.dart';
import '../../../shared/widgets/onda_widgets.dart';

class AlbumsTab extends ConsumerWidget {
  const AlbumsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(albumsProvider);
    final bottomPad = shellBottomPadding(context, ref);

    return albumsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EmptyState('Error: $e'),
      data: (albums) {
        final entries = albums.entries.toList()
          ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));
        if (entries.isEmpty) {
          return const EmptyState('No se encontraron álbumes');
        }
        return ListView.builder(
          padding: EdgeInsets.only(bottom: bottomPad),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final first = entry.value.first;
            final name =
                entry.key == 'Unknown Album' ? 'Álbum desconocido' : entry.key;
            return MediaRow(
              leading:
                  Artwork(audioId: first.audioId, seed: entry.key, size: 56),
              title: name,
              subtitle: 'Álbum · ${first.artistName ?? 'Artista desconocido'}',
              trailing: const DotsIcon(),
              onTap: () => openAlbum(context, entry.key),
            );
          },
        );
      },
    );
  }
}
