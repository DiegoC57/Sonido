import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/main_shell.dart';
import '../../shared/models/song.dart';
import '../../shared/providers/player_provider.dart';
import '../../shared/providers/song_provider.dart';
import '../../shared/widgets/song_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _play(List<Song> songs, int index) {
    ref.read(playerActionsProvider).playFromList(songs, index: index);
  }

  @override
  Widget build(BuildContext context) {
    final hasMedia = ref.watch(hasMediaProvider).asData?.value ?? false;
    final bottomPad = MediaQuery.of(context).padding.bottom +
        kBottomNavHeight +
        (hasMedia ? kMiniPlayerHeight : 0);
    final songs = ref.watch(songsProvider).asData?.value ?? const <Song>[];
    final query = _query.trim().toLowerCase();
    final results = query.isEmpty
        ? const <Song>[]
        : songs.where((s) {
            return s.title.toLowerCase().contains(query) ||
                (s.artistName?.toLowerCase().contains(query) ?? false) ||
                (s.albumName?.toLowerCase().contains(query) ?? false);
          }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: '¿Qué quieres escuchar?',
            border: InputBorder.none,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: query.isEmpty
          ? Center(
              child: Text(
                '¿Qué quieres escuchar?',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            )
          : results.isEmpty
              ? Center(
                  child: Text(
                    'Sin resultados para "$query"',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: bottomPad),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final song = results[index];
                    return SongTile(song: song, onTap: () => _play(results, index));
                  },
                ),
    );
  }
}
