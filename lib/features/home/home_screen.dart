import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/main_shell.dart';
import '../../shared/models/recent_play.dart';
import '../../shared/models/song.dart';
import '../../shared/providers/player_provider.dart';
import '../../shared/providers/recent_rotation_provider.dart';
import '../../shared/providers/song_provider.dart';
import '../../shared/theme/app_text_styles.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasMedia = ref.watch(hasMediaProvider).asData?.value ?? false;
    final bottomPad = MediaQuery.of(context).padding.bottom +
        kBottomNavHeight +
        (hasMedia ? kMiniPlayerHeight : 0);
    final recentAsync = ref.watch(recentRotationProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Inicio')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad),
        children: [
          Text(
            'Tu rotación reciente',
            style: appTitleLarge(fontSize: 22),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: recentAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (entries) {
                if (entries.isEmpty) {
                  return Center(
                    child: Text(
                      'Reproduce música para ver tu rotación aquí',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  );
                }
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => _RotationCard(entry: entries[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RotationCard extends ConsumerWidget {
  final RecentPlay entry;

  const _RotationCard({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkAsync = entry.representativeAudioId != null
        ? ref.watch(artworkProvider(entry.representativeAudioId!))
        : null;

    return GestureDetector(
      onTap: () => _playAlbum(ref),
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 140,
                height: 140,
                child: artworkAsync?.when(
                      loading: () => _placeholder(),
                      error: (_, _) => _placeholder(),
                      data: (bytes) =>
                          bytes == null ? _placeholder() : Image.memory(bytes, fit: BoxFit.cover),
                    ) ??
                    _placeholder(),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              entry.albumName ?? 'Álbum desconocido',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appListTitle().copyWith(fontSize: 13),
            ),
            Text(
              entry.artistName ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appSecondary(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade800,
      child: Icon(Icons.album, color: Colors.grey.shade600),
    );
  }

  void _playAlbum(WidgetRef ref) {
    final songs = ref.read(songsProvider).asData?.value ?? const <Song>[];
    final albumSongs =
        songs.where((s) => (s.albumName ?? 'Unknown Album') == entry.albumName).toList();
    if (albumSongs.isEmpty) return;
    ref.read(playerActionsProvider).playFromList(albumSongs);
  }
}
