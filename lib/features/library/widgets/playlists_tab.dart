import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/playlist_provider.dart';
import '../../../shared/widgets/artwork.dart';
import '../../../shared/widgets/onda_widgets.dart';

class PlaylistsTab extends ConsumerWidget {
  const PlaylistsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistsProvider);
    final bottomPad = shellBottomPadding(context, ref);

    return playlistsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const EmptyState('Error al cargar playlists'),
      data: (playlists) {
        if (playlists.isEmpty) {
          return const EmptyState(
              'Todavía no tienes playlists.\nCréalas con el botón +');
        }
        return ListView.builder(
          padding: EdgeInsets.only(bottom: bottomPad),
          itemCount: playlists.length,
          itemBuilder: (context, i) {
            final p = playlists[i];
            final count = p.songIds?.length ?? 0;
            return MediaRow(
              leading:
                  Artwork(audioId: null, seed: 'playlist-${p.name}', size: 56),
              title: p.name,
              subtitle:
                  'Playlist · $count ${count == 1 ? 'canción' : 'canciones'}',
              trailing: const DotsIcon(),
              onTap: () => context.push('/playlist/${p.id}'),
            );
          },
        );
      },
    );
  }
}
