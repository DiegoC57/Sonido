import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/theme/app_text_styles.dart';
import '../../shared/widgets/create_playlist_dialog.dart';
import 'widgets/albums_tab.dart';
import 'widgets/artists_tab.dart';
import 'widgets/folders_tab.dart';
import 'widgets/songs_tab.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  static const _categories = [
    'All',
    'Music',
    'Podcasts',
    'Audiobooks',
    'Álbumes',
    'Artistas',
    'Carpetas',
  ];
  int _categoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Tu Biblioteca'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final playlist = await showCreatePlaylistDialog(context, ref);
              if (playlist == null || !context.mounted) return;
              context.push('/playlist/${playlist.id}');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterChipRow(
            items: _categories,
            selectedIndex: _categoryIndex,
            onSelected: (i) => setState(() => _categoryIndex = i),
          ),
          Expanded(child: _content()),
        ],
      ),
    );
  }

  Widget _content() {
    switch (_categoryIndex) {
      case 0:
      case 1:
        return const SongsTab();
      case 2:
        return const _EmptyCategory(icon: Icons.podcasts, label: 'No tienes podcasts');
      case 3:
        return const _EmptyCategory(icon: Icons.menu_book, label: 'No tienes audiolibros');
      case 4:
        return const AlbumsTab();
      case 5:
        return const ArtistsTab();
      default:
        return const FoldersTab();
    }
  }
}

class _FilterChipRow extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _FilterChipRow({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return ChoiceChip(
            label: Text(items[index]),
            selected: selected,
            showCheckmark: false,
            onSelected: (_) => onSelected(index),
            selectedColor: primary,
            backgroundColor: Colors.grey.shade900,
            labelStyle: appChipLabel(color: selected ? Colors.black : Colors.white),
            shape: StadiumBorder(
              side: BorderSide(color: selected ? Colors.transparent : Colors.grey.shade700),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyCategory extends StatelessWidget {
  final IconData icon;
  final String label;

  const _EmptyCategory({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: Colors.grey.shade600),
          const SizedBox(height: 16),
          Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 18)),
        ],
      ),
    );
  }
}
