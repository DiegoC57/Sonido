import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/theme/onda.dart';
import '../../shared/widgets/create_playlist_dialog.dart';
import '../../shared/widgets/onda_widgets.dart';
import 'widgets/albums_tab.dart';
import 'widgets/artists_tab.dart';
import 'widgets/folders_tab.dart';
import 'widgets/playlists_tab.dart';
import 'widgets/songs_tab.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  static const _categories = [
    'Canciones',
    'Playlists',
    'Álbumes',
    'Artistas',
    'Carpetas',
  ];
  int _categoryIndex = 0;

  Future<void> _createPlaylist() async {
    final playlist = await showCreatePlaylistDialog(context, ref);
    if (playlist == null || !mounted) return;
    context.push('/playlist/${playlist.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Onda.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ScreenTitle(
                'Tu biblioteca',
                trailing: IconButton(
                  tooltip: 'Crear playlist',
                  onPressed: _createPlaylist,
                  icon: const Icon(Icons.add_rounded,
                      size: 26, color: Color(0xB3F4F2EE)),
                ),
              ),
            ),
            ChipRow(
              items: _categories,
              selectedIndex: _categoryIndex,
              onSelected: (i) => setState(() => _categoryIndex = i),
            ),
            const SizedBox(height: 18),
            Expanded(child: _content()),
          ],
        ),
      ),
    );
  }

  Widget _content() {
    switch (_categoryIndex) {
      case 0:
        return const SongsTab();
      case 1:
        return const PlaylistsTab();
      case 2:
        return const AlbumsTab();
      case 3:
        return const ArtistsTab();
      default:
        return const FoldersTab();
    }
  }
}
