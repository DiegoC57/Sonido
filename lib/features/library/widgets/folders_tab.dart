import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/song_provider.dart';

class FoldersTab extends ConsumerWidget {
  const FoldersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider);

    return foldersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (folders) {
        final entries = folders.entries.toList()
          ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder, size: 72, color: Colors.grey.shade600),
                const SizedBox(height: 16),
                Text('No se encontraron carpetas',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 18)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: entries.length,
          itemExtent: 64,
          itemBuilder: (context, index) {
            final entry = entries[index];
            entry.value.fold<int>(
                0, (sum, s) => sum + (s.duration ?? 0));

            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade800,
                child: Icon(Icons.folder, color: Colors.grey.shade500),
              ),
              title: Text(
                entry.key,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                '${entry.value.length} canciones',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              onTap: () {},
            );
          },
        );
      },
    );
  }
}
