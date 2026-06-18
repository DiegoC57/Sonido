import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/player_provider.dart';
import '../../shared/providers/song_provider.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaItem = ref.watch(currentMediaItemProvider).asData?.value;
    final isPlaying = ref.watch(isPlayingProvider);
    final position = ref.watch(positionProvider).asData?.value ?? Duration.zero;
    final duration = ref.watch(durationProvider).asData?.value ?? Duration.zero;
    final shuffle = ref.watch(shuffleModeProvider).asData?.value;
    final repeat = ref.watch(repeatModeProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reproduciendo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.queue_music),
            onPressed: () => _showQueue(context, ref),
          ),
        ],
      ),
      body: mediaItem == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.music_note, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Ninguna canción seleccionada',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _Artwork(mediaItem: mediaItem),
                  const SizedBox(height: 32),
                  Text(
                    mediaItem.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mediaItem.artist ?? 'Artista desconocido',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade400,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (mediaItem.album != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      mediaItem.album!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 24),
                  _SeekBar(
                    position: position,
                    duration: duration,
                    onChanged: (value) async {
                      final actions = ref.read(playerActionsProvider);
                      await actions.seek(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  _Controls(
                    isPlaying: isPlaying,
                    shuffleMode: shuffle ?? AudioServiceShuffleMode.none,
                    repeatMode: repeat ?? AudioServiceRepeatMode.none,
                  ),
                ],
              ),
            ),
    );
  }

  void _showQueue(BuildContext context, WidgetRef ref) {
    final queue = ref.read(queueProvider).asData?.value ?? [];
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Cola de reproducción',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(height: 1),
          if (queue.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('Cola vacía'),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: queue.length,
                itemBuilder: (context, index) {
                  final item = queue[index];
                  return ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(item.artist ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _Artwork extends ConsumerWidget {
  final MediaItem mediaItem;

  const _Artwork({required this.mediaItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioId = mediaItem.extras?['audioId'] as int?;
    final artworkAsync = audioId != null
        ? ref.watch(artworkProvider(audioId))
        : null;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade900,
        ),
        clipBehavior: Clip.antiAlias,
        child: artworkAsync?.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => _defaultArtwork(),
              data: (bytes) {
                if (bytes == null) return _defaultArtwork();
                return Image.memory(bytes, fit: BoxFit.cover);
              },
            ) ??
            _defaultArtwork(),
      ),
    );
  }

  Widget _defaultArtwork() {
    return Container(
      color: Colors.grey.shade800,
      child: Icon(Icons.music_note, size: 80, color: Colors.grey.shade600),
    );
  }
}

class _SeekBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onChanged;

  const _SeekBar({
    required this.position,
    required this.duration,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final totalMs = duration.inMilliseconds.toDouble();
    final posMs = position.inMilliseconds.toDouble().clamp(0, totalMs);

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
          ),
          child: Slider(
            value: totalMs > 0 ? posMs / totalMs : 0,
            onChanged: (value) {
              onChanged(Duration(milliseconds: (value * totalMs).round()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              Text(
                _formatDuration(duration),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _Controls extends ConsumerWidget {
  final bool isPlaying;
  final AudioServiceShuffleMode shuffleMode;
  final AudioServiceRepeatMode repeatMode;

  const _Controls({
    required this.isPlaying,
    required this.shuffleMode,
    required this.repeatMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(playerActionsProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ShuffleButton(mode: shuffleMode),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.skip_previous, size: 36),
              onPressed: () => actions.skipToPrevious(),
            ),
            const SizedBox(width: 16),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 40,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () => actions.togglePlayPause(),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.skip_next, size: 36),
              onPressed: () => actions.skipToNext(),
            ),
            const SizedBox(width: 16),
            _RepeatButton(mode: repeatMode),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => actions.skipToPrevious(),
              icon: const Icon(Icons.replay_10, size: 20),
              label: const Text('-10s'),
            ),
            const SizedBox(width: 32),
            TextButton.icon(
              onPressed: () => actions.seek(
                (ref.read(positionProvider).asData?.value ?? Duration.zero) +
                    const Duration(seconds: 10),
              ),
              icon: const Icon(Icons.forward_10, size: 20),
              label: const Text('+10s'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShuffleButton extends ConsumerWidget {
  final AudioServiceShuffleMode mode;

  const _ShuffleButton({required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = mode == AudioServiceShuffleMode.all;
    return IconButton(
      icon: Icon(
        Icons.shuffle,
        color: enabled ? Theme.of(context).colorScheme.primary : null,
      ),
      onPressed: () => ref.read(playerActionsProvider).toggleShuffle(),
    );
  }
}

class _RepeatButton extends ConsumerWidget {
  final AudioServiceRepeatMode mode;

  const _RepeatButton({required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IconData icon;
    Color? color;
    switch (mode) {
      case AudioServiceRepeatMode.one:
        icon = Icons.repeat_one;
        color = Theme.of(context).colorScheme.primary;
      case AudioServiceRepeatMode.all:
        icon = Icons.repeat;
        color = Theme.of(context).colorScheme.primary;
      default:
        icon = Icons.repeat;
        color = null;
    }
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: () => ref.read(playerActionsProvider).cycleRepeatMode(),
    );
  }
}
