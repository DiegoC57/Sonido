import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/song.dart';
import '../providers/player_provider.dart';
import '../providers/song_provider.dart';
import '../theme/app_text_styles.dart';
import 'equalizer_bars.dart';

class SongTile extends ConsumerWidget {
  final Song song;
  final VoidCallback? onTap;
  final VoidCallback? onPlayNext;
  final VoidCallback? onAddToQueue;

  const SongTile({
    super.key,
    required this.song,
    this.onTap,
    this.onPlayNext,
    this.onAddToQueue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkAsync = song.audioId != null
        ? ref.watch(artworkProvider(song.audioId!))
        : null;
    final currentItem = ref.watch(currentMediaItemProvider).asData?.value;
    final isCurrent = currentItem != null &&
        song.uri != null &&
        currentItem.id == song.uri;
    final isPlaying = ref.watch(isPlayingProvider);
    final nowPlayingColor = Theme.of(context).colorScheme.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 52,
          height: 52,
          child: artworkAsync?.when(
                loading: () => _defaultArtwork(),
                error: (_, _) => _defaultArtwork(),
                data: (bytes) {
                    if (bytes == null) return _defaultArtwork();
                    return Image.memory(bytes, fit: BoxFit.cover);
                  },
              ) ??
              _defaultArtwork(),
        ),
      ),
      title: Row(
        children: [
          if (isCurrent) ...[
            EqualizerBars(color: nowPlayingColor, animate: isPlaying),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appListTitle(color: isCurrent ? nowPlayingColor : Colors.white)
                  .copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
      subtitle: Text(
        song.artistName ?? 'Unknown Artist',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: appSecondary(fontSize: 11, color: Colors.grey.shade400),
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 20),
        onSelected: (value) => _onMenuSelected(context, value),
        itemBuilder: (_) => [
          const PopupMenuItem(
            value: 'play_next',
            child: ListTile(
              leading: Icon(Icons.skip_next),
              title: Text('Reproducir siguiente'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'add_queue',
            child: ListTile(
              leading: Icon(Icons.queue_music),
              title: Text('Agregar a cola'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'add_playlist',
            child: ListTile(
              leading: Icon(Icons.playlist_add),
              title: Text('Agregar a playlist'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _defaultArtwork() {
    return Container(
      color: Colors.grey.shade800,
      child: Icon(Icons.music_note, color: Colors.grey.shade500, size: 28),
    );
  }

  void _onMenuSelected(BuildContext context, String value) {
    switch (value) {
      case 'play_next':
        onPlayNext?.call();
      case 'add_queue':
        onAddToQueue?.call();
      case 'add_playlist':
        break;
    }
  }
}
