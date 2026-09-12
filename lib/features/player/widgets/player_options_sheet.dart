import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../shared/models/playlist.dart';
import '../../../shared/models/song.dart';
import '../../../shared/providers/player_provider.dart';
import '../../../shared/providers/song_provider.dart';
import '../../../shared/repositories/repository_providers.dart';
import '../../../shared/widgets/create_playlist_dialog.dart';
import 'queue_sheet.dart';
import 'sleep_timer_dialog.dart';

class PlayerOptionsSheet extends ConsumerWidget {
  final MediaItem mediaItem;

  const PlayerOptionsSheet({super.key, required this.mediaItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songId = mediaItem.extras?['songId'] as int?;
    final audioId = mediaItem.extras?['audioId'] as int?;
    final song = songId != null
        ? ref.watch(songByIdProvider(songId)).asData?.value
        : null;
    final isFavorite = song?.isFavorite ?? false;
    final primary = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: audioId != null
                        ? _ArtworkThumb(audioId: audioId)
                        : Container(color: Colors.grey.shade800),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mediaItem.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        mediaItem.artist ?? 'Artista desconocido',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('Compartir'),
            onTap: () {
              Navigator.pop(context);
              SharePlus.instance.share(
                ShareParams(
                  text: '${mediaItem.title} - ${mediaItem.artist ?? ''}',
                ),
              );
            },
          ),
          ListTile(
            enabled: false,
            leading: Icon(Icons.lyrics_outlined, color: Colors.grey.shade600),
            title: Text('Letras', style: TextStyle(color: Colors.grey.shade600)),
            trailing: Text(
              'Próximamente',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
          ListTile(
            leading: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? primary : null,
            ),
            title: Text(isFavorite ? 'Quitar de tus Me gusta' : 'Agregar a tus Me gusta'),
            onTap: songId == null
                ? null
                : () {
                    ref.read(playerActionsProvider).toggleFavorite(songId);
                    Navigator.pop(context);
                  },
          ),
          ListTile(
            leading: const Icon(Icons.playlist_add),
            title: const Text('Agregar a playlist'),
            onTap: song == null
                ? null
                : () {
                    Navigator.pop(context);
                    _showAddToPlaylist(context, ref, song);
                  },
          ),
          ListTile(
            leading: const Icon(Icons.queue_music_outlined),
            title: const Text('Agregar a la fila'),
            onTap: song == null
                ? null
                : () async {
                    await ref.read(playerActionsProvider).addToQueue(song);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Agregada a la fila')),
                    );
                  },
          ),
          ListTile(
            leading: const Icon(Icons.subject),
            title: const Text('Ir a la fila'),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.grey.shade900,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const QueueSheet(),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.nightlight_round),
            title: const Text('Apagado automático'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => const SleepTimerDialog(),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
          ),
        ),
      ),
    );
  }

  void _showAddToPlaylist(BuildContext context, WidgetRef ref, Song song) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddToPlaylistSheet(song: song),
    );
  }
}

class _ArtworkThumb extends ConsumerWidget {
  final int audioId;

  const _ArtworkThumb({required this.audioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkAsync = ref.watch(artworkProvider(audioId));
    return artworkAsync.when(
      loading: () => Container(color: Colors.grey.shade800),
      error: (_, _) => Container(color: Colors.grey.shade800),
      data: (bytes) {
        if (bytes == null) return Container(color: Colors.grey.shade800);
        return Image.memory(bytes, fit: BoxFit.cover);
      },
    );
  }
}

class _AddToPlaylistSheet extends ConsumerWidget {
  final Song song;

  const _AddToPlaylistSheet({required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(_playlistsProvider);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(Icons.playlist_add),
                SizedBox(width: 8),
                Text('Agregar a playlist', style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Crear nueva playlist'),
            onTap: () async {
              final playlist = await showCreatePlaylistDialog(context, ref);
              if (playlist == null) return;
              final repo = await ref.read(playlistRepositoryProvider.future);
              await repo.addSong(playlist.id, song.id);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
          ),
          Flexible(
            child: playlistsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Error: $e'),
              ),
              data: (playlists) {
                if (playlists.isEmpty) return const SizedBox.shrink();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = playlists[index];
                    return ListTile(
                      leading: const Icon(Icons.queue_music),
                      title: Text(playlist.name),
                      subtitle: Text('${playlist.songIds?.length ?? 0} canciones'),
                      onTap: () async {
                        final repo = await ref.read(playlistRepositoryProvider.future);
                        await repo.addSong(playlist.id, song.id);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Agregada a "${playlist.name}"')),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

final _playlistsProvider = FutureProvider<List<Playlist>>((ref) async {
  final repo = await ref.watch(playlistRepositoryProvider.future);
  return repo.getAll();
});
