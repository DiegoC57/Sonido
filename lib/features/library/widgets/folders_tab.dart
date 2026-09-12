import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/main_shell.dart';
import '../../../shared/providers/player_provider.dart';
import '../../../shared/providers/song_provider.dart';
import '../../../shared/theme/app_text_styles.dart';

class FoldersTab extends ConsumerWidget {
  const FoldersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider);
    final hasMedia = ref.watch(hasMediaProvider).asData?.value ?? false;
    final bottomPad = MediaQuery.of(context).padding.bottom +
        kBottomNavHeight +
        (hasMedia ? kMiniPlayerHeight : 0);

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
          padding: EdgeInsets.fromLTRB(0, 4, 0, bottomPad),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];

            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade800,
                child: Icon(Icons.folder, color: Colors.grey.shade500),
              ),
              title: Text(
                entry.key,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: appListTitle(),
              ),
              subtitle: Text(
                '${entry.value.length} canciones',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: appSecondary(fontSize: 13, color: Colors.grey.shade500),
              ),
              onTap: () {
                ref.read(playerActionsProvider).playFromList(entry.value);
              },
            );
          },
        );
      },
    );
  }
}
