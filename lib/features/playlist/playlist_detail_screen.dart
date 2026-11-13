import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/main_shell.dart';
import '../../shared/models/song.dart';
import '../../shared/providers/player_provider.dart';
import '../../shared/providers/playlist_provider.dart';
import '../../shared/theme/onda.dart';
import '../../shared/widgets/artwork.dart';
import '../../shared/widgets/onda_widgets.dart';
import '../../shared/widgets/song_tile.dart';

class PlaylistDetailScreen extends ConsumerWidget {
  final int playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlist = ref.watch(playlistByIdProvider(playlistId)).asData?.value;
    final songsAsync = ref.watch(playlistSongsProvider(playlistId));
    final songs = songsAsync.asData?.value ?? const <Song>[];
    final name = playlist?.name ?? 'Playlist';
    final seed = 'playlist-$name';
    final headerColor = coverStyleFor(seed).bg;
    final topPad = MediaQuery.of(context).padding.top;
    final actions = ref.read(playerActionsProvider);
    final totalMin =
        (songs.fold<int>(0, (s, e) => s + (e.duration ?? 0)) / 60000).round();

    return ScreenWithMiniPlayer(
      child: Scaffold(
        backgroundColor: Onda.bg,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 330 + topPad,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [headerColor, headerColor.withAlpha(0)],
                  ),
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.only(top: topPad + 8, bottom: 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(Onda.gutter, 0, Onda.gutter, 20),
                  child: Row(
                    children: [
                      RoundIconButton(
                        icon: Icons.chevron_left_rounded,
                        tooltip: 'Atrás',
                        size: 32,
                        background: const Color(0x660B0B0C),
                        iconColor: Onda.text,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Artwork(
                    audioId: songs.isEmpty ? null : songs.first.audioId,
                    seed: seed,
                    size: 188,
                    radius: 6,
                    texture: true,
                    shadow: const [
                      BoxShadow(color: Color(0x80000000), blurRadius: 40, offset: Offset(0, 18)),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Onda.gutter),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: Onda.display(26,
                              weight: FontWeight.w700, tracking: -0.03, height: 1.05)),
                      const SizedBox(height: 8),
                      Text(
                        'Playlist · ${songs.length} ${songs.length == 1 ? 'canción' : 'canciones'}, $totalMin min',
                        style: Onda.ui(11.5, color: Onda.text3),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Material(
                            color: songs.isEmpty ? Onda.surface3 : Onda.accent,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: songs.isEmpty ? null : () => actions.playFromList(songs),
                              child: SizedBox(
                                width: 52,
                                height: 52,
                                child: Icon(Icons.play_arrow_rounded,
                                    size: 30,
                                    semanticLabel: 'Reproducir playlist',
                                    color: songs.isEmpty ? Onda.text3 : Onda.onAccent),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          if (songs.isNotEmpty)
                            GestureDetector(
                              onTap: () => actions.playFromList([...songs]..shuffle()),
                              child: Text('ALEATORIO',
                                  style: Onda.mono(11,
                                      tracking: 0.1, color: const Color(0x8CF4F2EE))),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                if (songsAsync.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (songs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: EmptyState(
                        'Todavía no hay canciones en esta playlist.\nAgrégalas desde el menú ⋯ del reproductor'),
                  )
                else
                  for (final (i, song) in songs.indexed)
                    SongTile(
                      song: song,
                      onTap: () => actions.playFromList(songs, index: i),
                      onPlayNext: () => actions.playNext(song),
                      onAddToQueue: () => actions.addToQueue(song),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
