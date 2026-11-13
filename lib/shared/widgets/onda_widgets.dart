import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/main_shell.dart';
import '../theme/onda.dart';

/// Bottom padding so scrolling content clears the tab bar and mini player.
double shellBottomPadding(BuildContext context, WidgetRef ref) {
  final hasMedia = ref.watch(hasMediaProvider).asData?.value ?? false;
  return MediaQuery.of(context).padding.bottom +
      kBottomNavHeight +
      (hasMedia ? kMiniPlayerHeight : 0) +
      16;
}

/// Big screen title ("Buscar", "Tu biblioteca") with optional trailing.
class ScreenTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;
  final double size;

  const ScreenTitle(this.text, {super.key, this.trailing, this.size = 27});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Onda.gutter, 6, Onda.gutter - 8, 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: Onda.display(size, tracking: -0.025),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader(this.title, {super.key, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Onda.gutter, 0, Onda.gutter, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(title, style: Onda.display(18, tracking: -0.015)),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3, left: 12),
                child: Text(action!.toUpperCase(), style: Onda.mono(10)),
              ),
            ),
        ],
      ),
    );
  }
}

class MonoLabel extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final EdgeInsets padding;

  const MonoLabel(
    this.text, {
    super.key,
    this.color = Onda.text4,
    this.size = 10,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding,
        child: Text(
          text.toUpperCase(),
          style: Onda.mono(size, tracking: 0.14, color: color),
        ),
      );
}

class OndaChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const OndaChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? Onda.accent : Onda.surface3,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: Onda.ui(
              12.5,
              weight: FontWeight.w500,
              color: selected ? Onda.onAccent : const Color(0xCCF4F2EE),
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontally scrolling chip row.
class ChipRow extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ChipRow({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Onda.gutter),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => OndaChip(
          label: items[i],
          selected: i == selectedIndex,
          onTap: () => onSelected(i),
        ),
      ),
    );
  }
}

/// 34px round header button (`surface-5`).
class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final double size;
  final Color background;
  final Color iconColor;

  const RoundIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.size = 34,
    this.background = Onda.surface5,
    this.iconColor = Onda.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, size: size * 0.5, color: iconColor),
          ),
        ),
      ),
    );
  }
}

/// Vertical or horizontal three-dot "more" glyph from the design.
class DotsIcon extends StatelessWidget {
  final bool vertical;
  final Color color;

  const DotsIcon({super.key, this.vertical = true, this.color = Onda.textFaint});

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 3.5,
      height: 3.5,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
    final children = [dot, const SizedBox(width: 3.5, height: 3.5), dot,
        const SizedBox(width: 3.5, height: 3.5), dot];
    return vertical
        ? Column(mainAxisSize: MainAxisSize.min, children: children)
        : Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}

/// Library-style row: leading artwork, title, metadata, optional trailing.
class MediaRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? subtitleLeading;
  final Widget? trailing;
  final Color titleColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets padding;
  final double gap;
  final double titleSize;

  const MediaRow({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.subtitleLeading,
    this.trailing,
    this.titleColor = Onda.text,
    this.onTap,
    this.onLongPress,
    this.padding = const EdgeInsets.symmetric(horizontal: Onda.gutter, vertical: 9),
    this.gap = 13,
    this.titleSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      highlightColor: Onda.surface1,
      splashColor: Colors.transparent,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            leading,
            SizedBox(width: gap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Onda.ui(titleSize,
                        weight: FontWeight.w500, color: titleColor),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        if (subtitleLeading != null) ...[
                          subtitleLeading!,
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Onda.ui(11.5, color: Onda.text3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      ),
    );
  }
}

/// Centered empty-state message in the mono label style.
class EmptyState extends StatelessWidget {
  final String message;
  final Widget? action;

  const EmptyState(this.message, {super.key, this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.toUpperCase(),
              textAlign: TextAlign.center,
              style: Onda.mono(11, color: Onda.text3).copyWith(height: 1.6),
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

String formatMinSec(Duration d) {
  if (d.isNegative) d = Duration.zero;
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (d.inHours > 0) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    return '${d.inHours}:$m:$s';
  }
  return '${d.inMinutes}:$s';
}
