import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/song.dart';
import '../../shared/providers/player_provider.dart';
import '../../shared/providers/song_provider.dart';
import '../../shared/theme/onda.dart';
import '../../shared/widgets/artwork.dart';
import '../../shared/widgets/onda_widgets.dart';
import '../../shared/widgets/song_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _setQuery(String q) {
    _controller.text = q;
    _controller.selection = TextSelection.collapsed(offset: q.length);
    setState(() => _query = q);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = shellBottomPadding(context, ref);
    final songs = ref.watch(songsProvider).asData?.value ?? const <Song>[];
    final query = _query.trim().toLowerCase();
    final results = query.isEmpty
        ? const <Song>[]
        : songs.where((s) {
            return s.title.toLowerCase().contains(query) ||
                (s.artistName?.toLowerCase().contains(query) ?? false) ||
                (s.albumName?.toLowerCase().contains(query) ?? false) ||
                (s.genre?.toLowerCase().contains(query) ?? false);
          }).toList();

    final genreCounts = <String, int>{};
    for (final s in songs) {
      final g = s.genre?.trim();
      if (g == null || g.isEmpty) continue;
      genreCounts[g] = (genreCounts[g] ?? 0) + 1;
    }
    final genres = genreCounts.keys.toList()
      ..sort((a, b) => genreCounts[b]!.compareTo(genreCounts[a]!));

    return Scaffold(
      backgroundColor: Onda.bg,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => _focus.unfocus(),
          behavior: HitTestBehavior.translucent,
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: ScreenTitle('Buscar'),
                ),
              ),
              SliverToBoxAdapter(child: _searchField()),
              if (query.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: MonoLabel(
                    '${results.length} ${results.length == 1 ? 'resultado' : 'resultados'}',
                    padding: const EdgeInsets.fromLTRB(Onda.gutter, 0, Onda.gutter, 12),
                  ),
                ),
                SliverList.builder(
                  itemCount: results.length,
                  itemBuilder: (context, i) => SongTile(
                    song: results[i],
                    showTypeLabel: true,
                    onPlayNext: () =>
                        ref.read(playerActionsProvider).playNext(results[i]),
                    onAddToQueue: () =>
                        ref.read(playerActionsProvider).addToQueue(results[i]),
                    onTap: () {
                      _focus.unfocus();
                      ref
                          .read(playerActionsProvider)
                          .playFromList(results, index: i);
                    },
                  ),
                ),
              ] else if (genres.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(Onda.gutter, 4, Onda.gutter, 14),
                    child: Text('Explorar géneros', style: Onda.display(16)),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: Onda.gutter),
                  sliver: SliverGrid.builder(
                    itemCount: genres.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      mainAxisExtent: 88,
                    ),
                    itemBuilder: (_, i) => _GenreCard(
                      name: genres[i],
                      onTap: () => _setQuery(genres[i]),
                    ),
                  ),
                ),
              ] else
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState('Busca canciones, artistas o álbumes'),
                ),
              SliverToBoxAdapter(child: SizedBox(height: bottomPad)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchField() {
    const ink = Onda.bg;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Onda.gutter, 0, Onda.gutter, 20),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Onda.text,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, size: 19, color: ink),
            const SizedBox(width: 9),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                cursorColor: ink,
                textInputAction: TextInputAction.search,
                style: Onda.ui(14.5, color: ink),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Canciones, artistas, álbumes',
                  hintStyle: Onda.ui(14.5, color: const Color(0xFF6A6A6A)),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            if (_query.isNotEmpty)
              GestureDetector(
                onTap: () => _setQuery(''),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.close_rounded,
                      size: 18, color: Color(0xFF6A6A6A),
                      semanticLabel: 'Borrar búsqueda'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GenreCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _GenreCard({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = coverStyleFor(name);
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Container(
          color: style.bg,
          padding: const EdgeInsets.all(11),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -25,
                bottom: -25,
                width: 90,
                height: 90,
                child: Opacity(
                  opacity: .85,
                  child: GenerativeCover(seed: name, texture: false, scale: 1.1),
                ),
              ),
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Onda.display(14.5, tracking: -0.01),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
