import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/playlist.dart';
import '../providers/playlist_provider.dart';
import '../repositories/repository_providers.dart';

Future<Playlist?> showCreatePlaylistDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final controller = TextEditingController();
  final name = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Nueva playlist'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Nombre de la playlist'),
        onSubmitted: (v) {
          final trimmed = v.trim();
          if (trimmed.isNotEmpty) Navigator.pop(ctx, trimmed);
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            final trimmed = controller.text.trim();
            if (trimmed.isNotEmpty) Navigator.pop(ctx, trimmed);
          },
          child: const Text('Crear'),
        ),
      ],
    ),
  );

  if (name == null || name.isEmpty) return null;
  final repo = await ref.read(playlistRepositoryProvider.future);
  final playlist = await repo.create(name);
  ref.invalidate(playlistsProvider);
  return playlist;
}
