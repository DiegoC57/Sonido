import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/player_provider.dart';
import '../../../shared/providers/song_provider.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/marquee_text.dart';

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

    final titleAreaWidth = MediaQuery.of(context).size.width * 0.38;

    return Container(
      height: 52,
      margin: const EdgeInsets.fromLTRB(6, 0, 6, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            color: dominantColor ?? Colors.grey.shade900,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              final currentRoute = GoRouterState.of(context).uri.toString();
              if (currentRoute != '/player') {
                context.push('/player');
              }
            },
            child: Stack(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 6),
                    Hero(
                      tag: 'player_artwork',
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade800,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _MiniArtwork(audioId: audioId),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: titleAreaWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MarqueeText(
                            text: mediaItem.title,
                            playing: true,
                            height: 17,
                            maxWidth: titleAreaWidth,
                            style: appListTitle()
                                .copyWith(fontSize: 13, decoration: TextDecoration.none),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            mediaItem.artist ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: appSecondary(fontSize: 10, color: Colors.grey.shade400)
                                .copyWith(decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      icon: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        size: 24,
                      ),
                      color: Colors.white,
                      onPressed: () => actions.togglePlayPause(),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      icon: const Icon(Icons.skip_next_rounded, size: 24),
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
