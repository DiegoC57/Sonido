import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/player/widgets/mini_player.dart';
import '../shared/providers/player_provider.dart';
import '../shared/widgets/create_playlist_dialog.dart';

const kBottomNavHeight = 64.0;
const kMiniPlayerHeight = 52.0;

final hasMediaProvider = StreamProvider<bool>((ref) {
  final handler = ref.watch(audioHandlerProvider).asData?.value;
  if (handler == null) return Stream.value(false);
  return handler.mediaItem.stream.map((item) => item != null);
});

/// Wraps a standalone screen (outside the bottom-nav shell) with the
/// mini-player, e.g. the playlist detail screen.
class ScreenWithMiniPlayer extends ConsumerWidget {
  final Widget child;

  const ScreenWithMiniPlayer({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasMedia = ref.watch(hasMediaProvider).asData?.value ?? false;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        Expanded(child: child),
        if (hasMedia) ...[
          const MiniPlayer(),
          SizedBox(height: bottomPad),
        ],
      ],
    );
  }
}

class MainShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasMedia = ref.watch(hasMediaProvider).asData?.value ?? false;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: _TranslucentBottomBar(
        currentIndex: navigationShell.currentIndex,
        hasMedia: hasMedia,
        onTap: (index) => _onTap(context, ref, index),
      ),
    );
  }

  Future<void> _onTap(BuildContext context, WidgetRef ref, int index) async {
    if (index == 3) {
      final playlist = await showCreatePlaylistDialog(context, ref);
      if (playlist != null && context.mounted) {
        context.push('/playlist/${playlist.id}');
      }
      return;
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _TranslucentBottomBar extends StatelessWidget {
  final int currentIndex;
  final bool hasMedia;
  final ValueChanged<int> onTap;

  const _TranslucentBottomBar({
    required this.currentIndex,
    required this.hasMedia,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasMedia) const MiniPlayer(),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              padding: EdgeInsets.only(bottom: bottomPad),
              height: kBottomNavHeight + bottomPad,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(179),
                    Colors.black.withAlpha(242),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _NavItem(
                      icon: Icons.home_filled,
                      label: 'Home',
                      selected: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.search,
                      label: 'Search',
                      selected: currentIndex == 1,
                      onTap: () => onTap(1),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.library_music,
                      label: 'Tu Biblioteca',
                      selected: currentIndex == 2,
                      onTap: () => onTap(2),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.add_circle_outline,
                      label: 'Crear',
                      selected: false,
                      onTap: () => onTap(3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.grey.shade500;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: color, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
