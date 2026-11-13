import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/song.dart';
import '../providers/player_provider.dart';
import '../theme/onda.dart';
import 'artwork.dart';
import 'equalizer_bars.dart';
import 'onda_widgets.dart';

/// Track row: 48px cover · title · "Canción · artista" · mono duration · menu.
class SongTile extends ConsumerWidget {
  final Song song;
  final VoidCallback? onTap;
  final VoidCallback? onPlayNext;
  final VoidCallback? onAddToQueue;
  final bool showTypeLabel;

  const SongTile({
    super.key,
    required this.song,
    this.onTap,
    this.onPlayNext,
    this.onAddToQueue,
    this.showTypeLabel = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentItem = ref.watch(currentMediaItemProvider).asData?.value;
    final isCurrent =
        currentItem != null && song.uri != null && currentItem.id == song.uri;
    final isPlaying = ref.watch(isPlayingProvider);
    final artist = song.artistName ?? 'Artista desconocido';
    final duration = song.duration;

    final hasMenu = onPlayNext != null || onAddToQueue != null;

    return MediaRow(
      onTap: onTap,
      // With a menu, the dots' own 32px touch area provides the right inset,
      // so the trailing group sits near (not on) the screen edge.
      padding: EdgeInsets.fromLTRB(
          Onda.gutter, 8, hasMenu ? 6 : Onda.gutter, 8),
      gap: 12,
      titleSize: 13.5,
      leading: Artwork(
        audioId: song.audioId,
        seed: song.albumName ?? song.title,
        size: 48,
      ),
      title: song.title,
      titleColor: isCurrent ? Onda.accent : Onda.text,
      subtitle: showTypeLabel ? 'Canción · $artist' : artist,
      subtitleLeading: song.isFavorite
          ? const Icon(Icons.check_circle, size: 11, color: Onda.success)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 12),
          if (isCurrent)
            Padding(
              padding: EdgeInsets.only(right: hasMenu ? 4 : 0),
              child: EqualizerBars(color: Onda.accent, animate: isPlaying),
            )
          else if (duration != null && duration > 0)
            Padding(
              padding: EdgeInsets.only(right: hasMenu ? 2 : 0),
              child: Text(
                formatMinSec(Duration(milliseconds: duration)),
                style: Onda.mono(11, weight: FontWeight.w400, tracking: 0,
                    color: Onda.textFaint),
              ),
            ),
          if (hasMenu)
            PopupMenuButton<String>(
              tooltip: 'Más opciones',
              padding: EdgeInsets.zero,
              // Compact 32×44 touch target instead of the default 48px
              // IconButton, which pushed the dots far from the edge.
              child: const SizedBox(
                width: 32,
                height: 44,
                child: Center(child: DotsIcon()),
              ),
              onSelected: (value) {
                if (value == 'play_next') onPlayNext?.call();
                if (value == 'add_queue') onAddToQueue?.call();
              },
              itemBuilder: (_) => [
                if (onPlayNext != null)
                  const PopupMenuItem(
                    value: 'play_next',
                    child: Text('Reproducir a continuación'),
                  ),
                if (onAddToQueue != null)
                  const PopupMenuItem(
                    value: 'add_queue',
                    child: Text('Agregar a la cola'),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
