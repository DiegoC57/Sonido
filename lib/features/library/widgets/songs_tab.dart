import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/player_provider.dart';
import '../../../shared/providers/song_provider.dart';
import '../../../shared/theme/onda.dart';
import '../../../shared/widgets/onda_widgets.dart';
import '../../../shared/widgets/song_tile.dart';

class SongsTab extends ConsumerWidget {
  const SongsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(songsProvider);
    final bottomPad = shellBottomPadding(context, ref);
    final actions = ref.read(playerActionsProvider);

    return songsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EmptyState('Error al cargar canciones: $e'),
      data: (songs) {
        if (songs.isEmpty) {
          return EmptyState(
            'No se encontraron canciones',
            action: TextButton(
              onPressed: () => ref.read(songsProvider.notifier).refresh(),
              child: Text('ESCANEAR BIBLIOTECA',
                  style: Onda.mono(11, color: Onda.accent)),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(songsProvider.notifier).refresh(),
          color: Onda.accent,
          backgroundColor: Onda.surface5,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: bottomPad),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return SongTile(
                song: song,
                onTap: () => actions.playFromList(songs, index: index),
                onPlayNext: () => actions.playNext(song),
                onAddToQueue: () => actions.addToQueue(song),
              );
            },
          ),
        );
      },
    );
  }
}
