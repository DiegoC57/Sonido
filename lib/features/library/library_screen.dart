import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/albums_tab.dart';
import 'widgets/artists_tab.dart';
import 'widgets/folders_tab.dart';
import 'widgets/songs_tab.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Biblioteca'),
          bottom: const TabBar(
            isScrollable: false,
            tabs: [
              Tab(text: 'Canciones', icon: Icon(Icons.music_note, size: 20)),
              Tab(text: 'Álbumes', icon: Icon(Icons.album, size: 20)),
              Tab(text: 'Artistas', icon: Icon(Icons.person, size: 20)),
              Tab(text: 'Carpetas', icon: Icon(Icons.folder, size: 20)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SongsTab(),
            AlbumsTab(),
            ArtistsTab(),
            FoldersTab(),
          ],
        ),
      ),
    );
  }
}
