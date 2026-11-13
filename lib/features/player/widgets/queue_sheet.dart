import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/player_provider.dart';
import '../../../shared/theme/onda.dart';
import '../../../shared/widgets/artwork.dart';
import '../../../shared/widgets/equalizer_bars.dart';
import '../../../shared/widgets/onda_widgets.dart';

/// Opens the queue as a 78%-height bottom sheet (Onda spec).
Future<void> showQueueSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    sheetAnimationStyle: const AnimationStyle(
      duration: Onda.sheetDuration,
      curve: Onda.sheetCurve,
    ),
    builder: (_) => const FractionallySizedBox(
      heightFactor: 0.78,
      child: QueueSheet(),
    ),
  );
}

class QueueSheet extends ConsumerWidget {
  const QueueSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(queueProvider).asData?.value ?? const <MediaItem>[];
    final currentItem = ref.watch(currentMediaItemProvider).asData?.value;
    final isPlaying = ref.watch(isPlayingProvider);
    var currentIndex = ref.watch(currentIndexProvider).asData?.value ?? -1;
    if (currentIndex < 0 || currentIndex >= queue.length ||
        queue[currentIndex].id != currentItem?.id) {
      currentIndex = queue.indexWhere((i) => i.id == currentItem?.id);
    }
    final upcomingStart = currentIndex + 1;
    final upcoming =
        upcomingStart < queue.length ? queue.sublist(upcomingStart) : const <MediaItem>[];
    final actions = ref.read(playerActionsProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Onda.surface1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Onda.gutter, 14, 8, 4),
            child: Row(
              children: [
                Expanded(child: Text('Cola', style: Onda.display(16))),
                IconButton(
                  tooltip: 'Cerrar',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, size: 20, color: Onda.text2),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                if (currentItem != null) ...[
                  const SliverToBoxAdapter(
                    child: MonoLabel('Sonando ahora',
                        padding: EdgeInsets.fromLTRB(Onda.gutter, 8, Onda.gutter, 10)),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(Onda.gutter, 6, Onda.gutter, 16),
                      child: _QueueRow(
                        item: currentItem,
                        titleColor: Onda.accent,
                        trailing: EqualizerBars(color: Onda.accent, animate: isPlaying),
                      ),
                    ),
                  ),
                ],
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: Onda.gutter),
                    padding: const EdgeInsets.only(top: 16, bottom: 10),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Onda.divider)),
                    ),
                    child: const MonoLabel('A continuación'),
                  ),
                ),
                if (upcoming.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: EmptyState('No hay más canciones en la cola'),
                    ),
                  )
                else
                  SliverReorderableList(
                    itemCount: upcoming.length,
                    onReorder: (oldIndex, newIndex) {
                      if (newIndex > oldIndex) newIndex--;
                      actions.reorderQueue(
                          upcomingStart + oldIndex, upcomingStart + newIndex);
                    },
                    proxyDecorator: (child, _, _) => Material(
                      color: Onda.surface5,
                      elevation: 6,
                      borderRadius: BorderRadius.circular(8),
                      child: child,
                    ),
                    itemBuilder: (context, i) {
                      final item = upcoming[i];
                      final queueIndex = upcomingStart + i;
                      return Dismissible(
                        key: ValueKey('q_${item.id}_$queueIndex'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: Onda.gutter),
                          color: const Color(0xFF3A1E1C),
                          child: const Icon(Icons.delete_outline_rounded,
                              color: Color(0xFFE8503A)),
                        ),
                        onDismissed: (_) => actions.removeFromQueue(queueIndex),
                        child: InkWell(
                          onTap: () => ref
                              .read(audioHandlerProvider.future)
                              .then((h) => h.skipToQueueItem(queueIndex)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Onda.gutter, vertical: 7),
                            child: _QueueRow(
                              item: item,
                              trailing: ReorderableDragStartListener(
                                index: i,
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: _DragHandle(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 40 + MediaQuery.of(context).padding.bottom),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueRow extends StatelessWidget {
  final MediaItem item;
  final Color titleColor;
  final Widget trailing;

  const _QueueRow({
    required this.item,
    required this.trailing,
    this.titleColor = Onda.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Artwork(
          audioId: item.extras?['audioId'] as int?,
          seed: item.album ?? item.title,
          size: 44,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Onda.ui(13.5, weight: FontWeight.w500, color: titleColor),
              ),
              const SizedBox(height: 2),
              Text(
                item.artist ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Onda.ui(11.5, color: Onda.text3),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        trailing,
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    final line = Container(width: 13, height: 1.5, color: const Color(0x4DF4F2EE));
    return Semantics(
      label: 'Arrastrar para reordenar',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [line, const SizedBox(height: 3), line, const SizedBox(height: 3), line],
      ),
    );
  }
}
