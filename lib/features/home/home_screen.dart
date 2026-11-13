import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/router.dart' show openAlbum;
import '../../shared/models/recent_play.dart';
import '../../shared/models/song.dart';
import '../../shared/providers/player_provider.dart';
import '../../shared/providers/recent_rotation_provider.dart';
import '../../shared/providers/song_provider.dart';
import '../../shared/theme/onda.dart';
import '../../shared/widgets/artwork.dart';
import '../../shared/widgets/onda_widgets.dart';

const _unknownAlbum = 'Unknown Album';

String _greeting() {
  final h = DateTime.now().hour;
  if (h >= 6 && h < 12) return 'Buenos días';
  if (h >= 12 && h < 20) return 'Buenas tardes';
  return 'Buenas noches';
}

class _AlbumRef {
  final String name;
  final String? artist;
  final int? audioId;
  const _AlbumRef(this.name, this.artist, this.audioId);
}

class _Mix {
  final String title;
  final String kicker;
  final String sub;
  final List<Song> songs;
  const _Mix(this.title, this.kicker, this.sub, this.songs);
}

/// Up to three "daily mixes", each built from a handful of artists. Seeded
/// by the date so they stay stable during the day and change tomorrow.
final _mixesProvider = Provider<List<_Mix>>((ref) {
  final songs = ref.watch(songsProvider).asData?.value ?? const <Song>[];
  if (songs.isEmpty) return const [];
  final byArtist = <String, List<Song>>{};
  for (final s in songs) {
    byArtist.putIfAbsent(s.artistName ?? 'Artista desconocido', () => []).add(s);
  }
  final now = DateTime.now();
  final rnd = Random(now.year * 1000 + now.month * 50 + now.day);
  final artists = byArtist.keys.toList()..shuffle(rnd);
  final mixes = <_Mix>[];
  const perMix = 3;
  for (var i = 0; i < 3 && i * perMix < artists.length; i++) {
    final names = artists.skip(i * perMix).take(perMix).toList();
    final list = [for (final a in names) ...byArtist[a]!]..shuffle(rnd);
    if (list.isEmpty) continue;
    mixes.add(_Mix(
      'Mezcla diaria ${(i + 1).toString().padLeft(2, '0')}',
      names.map((n) => n.split(' ').first).join(' · ').toUpperCase(),
      '${list.length} canciones · se renueva cada día',
      list,
    ));
  }
  return mixes;
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPad = shellBottomPadding(context, ref);
    final songsAsync = ref.watch(songsProvider);
    final songs = songsAsync.asData?.value ?? const <Song>[];
    final recents = ref.watch(recentRotationProvider).asData?.value ??
        const <RecentPlay>[];
    final albums = ref.watch(albumsProvider).asData?.value ?? const {};
    final mixes = ref.watch(_mixesProvider);

    final recentAlbums = [
      for (final r in recents)
        _AlbumRef(r.albumName ?? _unknownAlbum, r.artistName,
            r.representativeAudioId),
    ];

    // Quick access: recent albums first, topped up with library albums.
    final quick = <_AlbumRef>[...recentAlbums.take(6)];
    for (final e in albums.entries) {
      if (quick.length >= 6) break;
      if (quick.any((q) => q.name == e.key)) continue;
      final first = e.value.first;
      quick.add(_AlbumRef(e.key, first.artistName, first.audioId));
    }

    final fresh = [...songs]
      ..sort((a, b) => (b.dateAdded ?? DateTime(0))
          .compareTo(a.dateAdded ?? DateTime(0)));
    final freshTop = fresh.take(10).toList();

    return Scaffold(
      backgroundColor: Onda.bg,
      body: SafeArea(
        bottom: false,
        child: songsAsync.isLoading && songs.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.only(top: 8, bottom: bottomPad),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        Onda.gutter, 8, Onda.gutter, 18),
                    child: Text(_greeting(), style: Onda.display(23)),
                  ),
                  if (songs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 120),
                      child: EmptyState(
                          'Aún no hay música en tu biblioteca.\nAgrega canciones a tu teléfono para empezar.'),
                    ),
                  if (quick.isNotEmpty) _QuickGrid(items: quick),
                  if (recentAlbums.isNotEmpty) ...[
                    const SectionHeader('Sigue escuchando'),
                    _Carousel(
                      height: 146 + 46,
                      itemCount: recentAlbums.length,
                      itemBuilder: (i) => _CoverCard(
                        size: 146,
                        album: recentAlbums[i],
                        onTap: () => openAlbum(context, recentAlbums[i].name),
                      ),
                    ),
                    const SizedBox(height: Onda.sectionGap),
                  ],
                  if (mixes.isNotEmpty) ...[
                    const SectionHeader('Mezclas para ti'),
                    _Carousel(
                      height: 160 + 50,
                      itemCount: mixes.length,
                      itemBuilder: (i) => _MixCard(
                        mix: mixes[i],
                        onTap: () => ref
                            .read(playerActionsProvider)
                            .playFromList(mixes[i].songs),
                      ),
                    ),
                    const SizedBox(height: Onda.sectionGap),
                  ],
                  if (freshTop.isNotEmpty) ...[
                    const SectionHeader('Agregadas recientemente'),
                    _Carousel(
                      height: 126 + 46,
                      itemCount: freshTop.length,
                      itemBuilder: (i) {
                        final s = freshTop[i];
                        return _CoverCard(
                          size: 126,
                          small: true,
                          album: _AlbumRef(s.title, s.artistName, s.audioId),
                          seed: s.albumName ?? s.title,
                          onTap: () => ref
                              .read(playerActionsProvider)
                              .playFromList(freshTop, index: i),
                        );
                      },
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _QuickGrid extends StatelessWidget {
  final List<_AlbumRef> items;

  const _QuickGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Onda.gutter, 0, Onda.gutter, Onda.sectionGap),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          mainAxisExtent: 52,
        ),
        itemBuilder: (context, i) {
          final a = items[i];
          return Material(
            color: Onda.surface2,
            borderRadius: BorderRadius.circular(7),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => openAlbum(context, a.name),
              hoverColor: Onda.surface2Hover,
              highlightColor: Onda.surface2Hover,
              child: Row(
                children: [
                  Artwork(audioId: a.audioId, seed: a.name, size: 52, radius: 0),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        a.name == _unknownAlbum ? 'Álbum desconocido' : a.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Onda.ui(12.5,
                            weight: FontWeight.w500, height: 1.25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Carousel extends StatelessWidget {
  final double height;
  final int itemCount;
  final Widget Function(int) itemBuilder;

  const _Carousel({
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Onda.gutter),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(width: Onda.carouselGap),
        itemBuilder: (_, i) => itemBuilder(i),
      ),
    );
  }
}

class _CoverCard extends StatelessWidget {
  final double size;
  final _AlbumRef album;
  final Object? seed;
  final bool small;
  final VoidCallback onTap;

  const _CoverCard({
    required this.size,
    required this.album,
    required this.onTap,
    this.seed,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: size,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Artwork(
              audioId: album.audioId,
              seed: seed ?? album.name,
              size: size,
              radius: 8,
              texture: true,
            ),
            const SizedBox(height: 9),
            Text(
              album.name == _unknownAlbum ? 'Álbum desconocido' : album.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Onda.ui(small ? 12.5 : 13,
                  weight: FontWeight.w500, height: 1.3),
            ),
            const SizedBox(height: 2),
            Text(
              album.artist ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Onda.ui(small ? 11 : 11.5, color: Onda.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _MixCard extends StatelessWidget {
  final _Mix mix;
  final VoidCallback onTap;

  const _MixCard({required this.mix, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = coverStyleFor(mix.title);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 160,
                height: 160,
                color: style.bg,
                child: Stack(
                  children: [
                    // Decorative shape bleeding off the top-right corner.
                    Positioned(
                      right: -18,
                      top: -18,
                      width: 110,
                      height: 110,
                      child: Opacity(
                        opacity: .9,
                        child: GenerativeCover(
                            seed: mix.title, texture: false, scale: 1.6),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mix.title.toUpperCase(),
                            maxLines: 2,
                            style: Onda.display(19,
                                weight: FontWeight.w700, height: 1.05),
                          ),
                          const SizedBox(height: 6),
                          Opacity(
                            opacity: .75,
                            child: Text(
                              mix.kicker,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Onda.mono(9.5, color: Onda.text),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              mix.sub,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Onda.ui(11.5, color: Onda.text3, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}
