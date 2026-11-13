import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/player_provider.dart';
import '../../../shared/providers/song_provider.dart';
import '../../../shared/theme/onda.dart';
import '../../../shared/widgets/onda_widgets.dart';

class FoldersTab extends ConsumerWidget {
  const FoldersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider);
    final bottomPad = shellBottomPadding(context, ref);

    return foldersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EmptyState('Error: $e'),
      data: (folders) {
        final entries = folders.entries.toList()
          ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));
        if (entries.isEmpty) {
          return const EmptyState('No se encontraron carpetas');
        }
        return ListView.builder(
          padding: EdgeInsets.only(bottom: bottomPad),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return MediaRow(
              leading: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Onda.surface3,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(Icons.folder_outlined, color: Onda.text3),
              ),
              title: entry.key,
              subtitle: 'Carpeta · ${entry.value.length} canciones',
              onTap: () =>
                  ref.read(playerActionsProvider).playFromList(entry.value),
            );
          },
        );
      },
    );
  }
}
