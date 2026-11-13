import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/song.dart';
import '../../shared/providers/player_provider.dart';
import '../../shared/providers/song_provider.dart';
import '../../shared/theme/onda.dart';
import '../../shared/widgets/artwork.dart';
import '../../shared/widgets/onda_widgets.dart';

const _unknownAlbum = 'Unknown Album';

class AlbumScreen extends ConsumerWidget {
  final String albumName;

  const AlbumScreen({super.key, required this.albumName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(albumsProvider);
    final songs = [...(albums.asData?.value[albumName] ?? const <Song>[])]
      ..sort((a, b) => (a.trackNumber ?? 9999).compareTo(b.trackNumber ?? 9999));

    final first = songs.isEmpty ? null : songs.first;
    final audioId = first?.audioId;
    final albumColor = audioId != null
        ? ref.watch(dominantColorProvider(audioId)).asData?.value
        : null;
    final headerColor = albumColor ?? coverStyleFor(albumName).bg;

    final current = ref.watch(currentMediaItemProvider).asData?.value;
    final isPlaying = ref.watch(isPlayingProvider);
    final albumIsCurrent =
        current != null && songs.any((s) => s.uri == current.id);

    final totalMs = songs.fold<int>(0, (sum, s) => sum + (s.duration ?? 0));
    final years = songs.map((s) => s.year).whereType<int>().where((y) => y > 0);
    final year = years.isEmpty ? null : years.reduce((a, b) => a > b ? a : b);
    final artist = first?.artistName ?? 'Artista desconocido';
    final title = albumName == _unknownAlbum ? 'Álbum desconocido' : albumName;
    final meta = [
      'Álbum',
      ?year?.toString(),
      '${songs.length} ${songs.length == 1 ? 'canción' : 'canciones'}, '
          '${(totalMs / 60000).round()} min',
    ].join(' · ');

    final actions = ref.read(playerActionsProvider);
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Onda.bg,
      body: Stack(
        children: [
          // 330px wash from the album color down to transparent.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 330 + topPad,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
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
            padding: EdgeInsets.only(
              top: topPad + 8,
              bottom: shellBottomPadding(context, ref),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    Onda.gutter, 0, Onda.gutter - 8, 20),
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
                    const Spacer(),
                    PopupMenuButton<String>(
                      tooltip: 'Más opciones',
                      icon: const DotsIcon(
                          vertical: false, color: Color(0xB3F4F2EE)),
                      onSelected: (v) async {
                        if (v != 'queue') return;
                        for (final s in songs) {
                          await actions.addToQueue(s);
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Álbum agregado a la cola')),
                          );
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'queue',
                          child: Text('Agregar a la cola'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: Artwork(
                  audioId: audioId,
                  seed: albumName,
                  size: 188,
                  radius: 6,
                  texture: true,
                  shadow: const [
                    BoxShadow(
                      color: Color(0x80000000),
                      blurRadius: 40,
                      offset: Offset(0, 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Onda.gutter),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Onda.display(26,
                          weight: FontWeight.w700, tracking: -0.03, height: 1.05),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _ArtistAvatar(name: artist),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Onda.ui(13, weight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(meta, style: Onda.ui(11.5, color: Onda.text3)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _PlayButton(
                          playing: albumIsCurrent && isPlaying,
                          onTap: songs.isEmpty
                              ? null
                              : () {
                                  if (albumIsCurrent) {
                                    actions.togglePlayPause();
                                  } else {
                                    actions.playFromList(songs);
                                  }
                                },
                        ),
                        const SizedBox(width: 20),
                        _TextAction(
                          'Aleatorio',
                          onTap: songs.isEmpty
                              ? null
                              : () => actions.playFromList(
                                    [...songs]..shuffle(),
                                  ),
                        ),
                        const SizedBox(width: 18),
                        // Local files are always available offline.
                        const _TextAction('Offline', color: Onda.success),
                      ],
                    ),
                    const SizedBox(height: 10),
                    for (final (i, s) in songs.indexed)
                      _TrackRow(
                        number: i + 1,
                        song: s,
                        active: current?.id == s.uri,
                        onTap: () => actions.playFromList(songs, index: i),
                      ),
                    if (songs.isEmpty && !albums.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: EmptyState('Este álbum ya no está en tu biblioteca'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArtistAvatar extends StatelessWidget {
  final String name;

  const _ArtistAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2E),
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: Onda.ui(9.5, weight: FontWeight.w600, color: const Color(0xFFE4E0D8)),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final bool playing;
  final VoidCallback? onTap;

  const _PlayButton({required this.playing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: playing ? 'Pausar' : 'Reproducir álbum',
      child: Material(
        color: Onda.accent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 52,
            height: 52,
            child: Icon(
              playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 30,
              color: Onda.onAccent,
            ),
          ),
        ),
      ),
    );
  }
}

class _TextAction extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;

  const _TextAction(this.label, {this.onTap, this.color = const Color(0x8CF4F2EE)});

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label.toUpperCase(),
      style: Onda.mono(11, tracking: 0.1, color: color),
    );
    if (onTap == null) return text;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: text),
    );
  }
}

class _TrackRow extends StatelessWidget {
  final int number;
  final Song song;
  final bool active;
  final VoidCallback onTap;

  const _TrackRow({
    required this.number,
    required this.song,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ms = song.duration ?? 0;
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Onda.surface1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Onda.divider)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child: Text(
                number.toString().padLeft(2, '0'),
                style: Onda.mono(11, weight: FontWeight.w400, tracking: 0,
                    color: active ? Onda.accent : Onda.textFaint),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Onda.ui(14,
                        weight: FontWeight.w500,
                        color: active ? Onda.accent : Onda.text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song.artistName ?? 'Artista desconocido',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Onda.ui(11.5, color: const Color(0x73F4F2EE)),
                  ),
                ],
              ),
            ),
            if (ms > 0)
              Text(
                formatMinSec(Duration(milliseconds: ms)),
                style: Onda.mono(11, weight: FontWeight.w400, tracking: 0,
                    color: Onda.textFaint),
              ),
          ],
        ),
      ),
    );
  }
}
