import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/player_provider.dart';

class QueueSheet extends ConsumerWidget {
  const QueueSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAsync = ref.watch(queueProvider);
    final queue = queueAsync.asData?.value ?? [];
    final currentItem = ref.watch(currentMediaItemProvider).asData?.value;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              const Icon(Icons.queue_music, size: 20),
              const SizedBox(width: 8),
              Text(
                'Cola de reproducción',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              if (queue.isNotEmpty)
                Text(
                  '${queue.length} canciones',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        if (queue.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.queue_music, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'Cola vacía',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        else
          Flexible(
            child: ReorderableListView.builder(
              shrinkWrap: true,
              itemCount: queue.length,
              buildDefaultDragHandles: false,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex--;
                final actions = ref.read(playerActionsProvider);
                actions.reorderQueue(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final item = queue[index];
                final isCurrent = item.id == currentItem?.id;
                return _QueueItem(
                  key: ValueKey('queue_${item.id}_$index'),
                  item: item,
                  index: index,
                  isCurrent: isCurrent,
                  onDelete: () {
                    final actions = ref.read(playerActionsProvider);
                    actions.removeFromQueue(index);
                  },
                );
              },
            ),
          ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }
}

class _QueueItem extends StatelessWidget {
  final MediaItem item;
  final int index;
  final bool isCurrent;
  final VoidCallback onDelete;

  const _QueueItem({
    super.key,
    required this.item,
    required this.index,
    required this.isCurrent,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('dismiss_${item.id}_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade900,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: ReorderableDragStartListener(
          index: index,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.drag_handle,
              size: 18,
              color: Colors.grey.shade400,
            ),
          ),
        ),
        title: Row(
          children: [
            if (isCurrent)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.play_arrow,
                  size: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            Expanded(
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          item.artist ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(Icons.close, size: 18, color: Colors.grey.shade400),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
