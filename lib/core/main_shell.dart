import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/player/widgets/mini_player.dart';
import '../shared/providers/player_provider.dart';
import '../shared/theme/onda.dart';
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
      backgroundColor: Onda.bg,
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
        // Mini player is intentionally left exactly as it was.
        if (hasMedia) const MiniPlayer(),
        Container(
          height: kBottomNavHeight + bottomPad,
          padding: EdgeInsets.only(top: 8, bottom: bottomPad),
          decoration: const BoxDecoration(
            color: Onda.bg,
            border: Border(top: BorderSide(color: Onda.divider)),
          ),
          child: Row(
            children: [
              for (final (i, tab) in _tabs.indexed)
                Expanded(
                  child: _NavItem(
                    icon: tab.$1,
                    label: tab.$2,
                    // "Crear" is an action, never a selected destination.
                    selected: i < 3 && currentIndex == i,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static const _tabs = [
    (_NavIcon.home, 'Inicio'),
    (_NavIcon.search, 'Buscar'),
    (_NavIcon.library, 'Biblioteca'),
    (_NavIcon.create, 'Crear'),
  ];
}

enum _NavIcon { home, search, library, create }

class _NavItem extends StatelessWidget {
  final _NavIcon icon;
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
    final color = selected ? Onda.text : Onda.navInactive;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 21,
              height: 21,
              child: CustomPaint(painter: _NavIconPainter(icon, color)),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: Onda.ui(10, weight: FontWeight.w500, color: color)
                  .copyWith(letterSpacing: 0.1),
            ),
          ],
        ),
      ),
    );
  }
}

/// Line icons from the Onda tab bar (21px, stroke 1.6).
class _NavIconPainter extends CustomPainter {
  final _NavIcon icon;
  final Color color;

  _NavIconPainter(this.icon, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 21);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = color;

    switch (icon) {
      case _NavIcon.home:
        final p = Path()
          ..moveTo(2.5, 8.6)
          ..lineTo(10.5, 2)
          ..lineTo(18.5, 8.6)
          ..lineTo(18.5, 18)
          ..arcToPoint(const Offset(17.5, 19), radius: const Radius.circular(1))
          ..lineTo(3.5, 19)
          ..arcToPoint(const Offset(2.5, 18), radius: const Radius.circular(1))
          ..close();
        canvas.drawPath(p, stroke);
      case _NavIcon.search:
        canvas.drawCircle(const Offset(9, 9), 6.6, stroke);
        canvas.drawLine(const Offset(13.9, 13.9), const Offset(19, 19), stroke);
      case _NavIcon.library:
        canvas.drawRect(const Rect.fromLTWH(2, 4, 2.2, 14), fill);
        canvas.drawRect(const Rect.fromLTWH(7, 2, 2.2, 16), fill);
        canvas.drawRect(const Rect.fromLTWH(12, 6, 2.2, 12), fill);
        canvas.drawRect(const Rect.fromLTWH(17, 3.5, 2.2, 14.5), fill);
      case _NavIcon.create:
        canvas.drawCircle(const Offset(10.5, 10.5), 8.6, stroke);
        canvas.drawLine(const Offset(10.5, 6.5), const Offset(10.5, 14.5), stroke);
        canvas.drawLine(const Offset(6.5, 10.5), const Offset(14.5, 10.5), stroke);
    }
  }

  @override
  bool shouldRepaint(_NavIconPainter old) =>
      old.icon != icon || old.color != color;
}
