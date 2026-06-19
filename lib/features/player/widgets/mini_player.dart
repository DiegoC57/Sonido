import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/player_provider.dart';
import '../../../shared/providers/song_provider.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaItem = ref.watch(currentMediaItemProvider).asData?.value;
    final isPlaying = ref.watch(isPlayingProvider);
    final position = ref.watch(positionProvider).asData?.value ?? Duration.zero;
    final duration = ref.watch(durationProvider).asData?.value ?? Duration.zero;
    final actions = ref.read(playerActionsProvider);

    if (mediaItem == null) return const SizedBox.shrink();

    final audioId = mediaItem.extras?['audioId'] as int?;
    final dominantColor = audioId != null
        ? ref.watch(dominantColorProvider(audioId)).asData?.value
        : null;

    final progress = duration.inMilliseconds > 0
        ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      height: 64,
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            color: dominantColor?.withAlpha(100) ?? Colors.grey.shade900,
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      final currentRoute = GoRouterState.of(context).uri.toString();
                      if (currentRoute != '/player') {
                        context.push('/player');
                      }
                    },
                    child: Row(
                      children: [
                        Hero(
                          tag: 'player_artwork',
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade800,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _MiniArtwork(audioId: audioId),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mediaItem.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                mediaItem.artist ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade300,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 28,
                    ),
                    color: Colors.white,
                    onPressed: () => actions.togglePlayPause(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded, size: 28),
                    color: Colors.white,
                    onPressed: () => actions.skipToNext(),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(height: 1, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniArtwork extends ConsumerWidget {
  final int? audioId;

  const _MiniArtwork({this.audioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (audioId == null) return _default();
    final artworkAsync = ref.watch(artworkProvider(audioId!));
    return artworkAsync.when(
      loading: () => _default(),
      error: (_, _) => _default(),
      data: (bytes) {
        if (bytes == null) return _default();
        return Image.memory(bytes, fit: BoxFit.cover);
      },
    );
  }

  Widget _default() {
    return Container(
      color: Colors.grey.shade800,
      child: Icon(Icons.music_note, size: 24, color: Colors.grey.shade600),
    );
  }
}
