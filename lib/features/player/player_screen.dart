import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../shared/providers/player_provider.dart';
import '../../shared/providers/song_provider.dart';
import '../../shared/theme/onda.dart';
import '../../shared/widgets/artwork.dart';
import '../../shared/widgets/onda_widgets.dart';
import 'widgets/player_options_sheet.dart';
import 'widgets/queue_sheet.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  double _volumeGestureDelta = 0;

  @override
  Widget build(BuildContext context) {
    final mediaItem = ref.watch(currentMediaItemProvider).asData?.value;
    final media = MediaQuery.of(context);

    if (mediaItem == null) {
      return const Scaffold(
        backgroundColor: Onda.bg,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final audioId = mediaItem.extras?['audioId'] as int?;
    final seed = mediaItem.album ?? mediaItem.title;
    // Same color source as the mini player so both stay in sync.
    final albumColor = (audioId != null
            ? ref.watch(dominantColorProvider(audioId)).asData?.value
            : null) ??
        coverStyleFor(seed).bg;
    final vivid = (audioId != null
            ? ref.watch(vividColorProvider(audioId)).asData?.value
            : null) ??
        coverStyleFor(seed).fg;

    final actions = ref.read(playerActionsProvider);

    return Scaffold(
      backgroundColor: Onda.bg,
      body: Stack(
        children: [
          // Layer 1: solid album color (animated between tracks).
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              color: albumColor,
            ),
          ),
          // Layer 2: fade to the app background behind the controls.
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x000B0B0C),
                    Color(0x400B0B0C),
                    Color(0xD90B0B0C),
                    Onda.bg,
                  ],
                  stops: [0, .35, .75, 1],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              Onda.playerGutter,
              media.padding.top + 8,
              Onda.playerGutter,
              media.padding.bottom + 28,
            ),
            child: Column(
              children: [
                _Header(
                  album: mediaItem.album,
                  onClose: () => Navigator.of(context).pop(),
                  onMore: () => _showOptions(context, mediaItem),
                ),
                Expanded(
                  child: _Cover(
                    audioId: audioId,
                    seed: seed,
                    itemId: mediaItem.id,
                    onSwipeLeft: actions.skipToNext,
                    onSwipeRight: actions.skipToPrevious,
                    onVerticalDrag: (delta) {
                      _volumeGestureDelta += delta;
                      final normalized =
                          (_volumeGestureDelta / 300).clamp(-1.0, 1.0);
                      actions.setVolume((normalized + 1) / 2);
                    },
                  ),
                ),
                const SizedBox(height: 26),
                _TitleRow(mediaItem: mediaItem),
                const SizedBox(height: 14),
                _ProgressBar(color: vivid),
                const SizedBox(height: 14),
                const _Controls(),
                const SizedBox(height: 26),
                _Footer(
                  onDevice: () => _showConnect(context),
                  onShare: () => SharePlus.instance.share(ShareParams(
                    text: '${mediaItem.title} - ${mediaItem.artist ?? ''}',
                  )),
                  onQueue: () => showQueueSheet(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context, MediaItem mediaItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => PlayerOptionsSheet(mediaItem: mediaItem),
    );
  }

  void _showConnect(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(Onda.gutter, 20, Onda.gutter, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dispositivos', style: Onda.display(16)),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(Icons.smartphone_rounded, color: Onda.success, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Este teléfono',
                          style: Onda.ui(14, weight: FontWeight.w500,
                              color: Onda.success)),
                      const SizedBox(height: 2),
                      Text('Reproduciendo aquí',
                          style: Onda.ui(11.5, color: Onda.text3)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const MonoLabel('Los auriculares Bluetooth conectados se usan automáticamente'),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String? album;
  final VoidCallback onClose;
  final VoidCallback onMore;

  const _Header({required this.album, required this.onClose, required this.onMore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Transform.translate(
            offset: const Offset(-8, 0),
            child: IconButton(
              tooltip: 'Cerrar reproductor',
              onPressed: onClose,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 28, color: Onda.text),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text('REPRODUCIENDO DE',
                    style: Onda.mono(9, tracking: 0.16, color: Onda.text3)),
                const SizedBox(height: 4),
                Text(
                  album ?? 'Tu biblioteca',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Onda.ui(12, weight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(8, 0),
            child: IconButton(
              tooltip: 'Más opciones',
              onPressed: onMore,
              icon: const DotsIcon(vertical: false, color: Color(0xB3F4F2EE)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final int? audioId;
  final Object seed;
  final String itemId;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final ValueChanged<double> onVerticalDrag;

  const _Cover({
    required this.audioId,
    required this.seed,
    required this.itemId,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onVerticalDrag,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final side = c.maxWidth < c.maxHeight ? c.maxWidth : c.maxHeight;
      return Center(
        child: GestureDetector(
          onHorizontalDragEnd: (d) {
            final v = d.primaryVelocity ?? 0;
            if (v < -300) onSwipeLeft();
            if (v > 300) onSwipeRight();
          },
          onVerticalDragUpdate: (d) => onVerticalDrag(d.primaryDelta ?? 0),
          // One Hero around the switcher: while two covers cross-fade they
          // must not both carry the same hero tag.
          child: Hero(
            tag: 'player_artwork',
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: Artwork(
                key: ValueKey('cover_$itemId'),
                audioId: audioId,
                seed: seed,
                size: side,
                radius: 10,
                texture: true,
                shadow: const [
                  BoxShadow(
                    color: Color(0x8C000000),
                    blurRadius: 60,
                    offset: Offset(0, 30),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _TitleRow extends ConsumerWidget {
  final MediaItem mediaItem;

  const _TitleRow({required this.mediaItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songId = mediaItem.extras?['songId'] as int?;
    final song =
        songId != null ? ref.watch(songByIdProvider(songId)).asData?.value : null;
    final saved = song?.isFavorite ?? false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Column(
              key: ValueKey(mediaItem.id),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mediaItem.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Onda.display(24,
                      weight: FontWeight.w700, tracking: -0.03, height: 1.1),
                ),
                const SizedBox(height: 5),
                Text(
                  mediaItem.artist ?? 'Artista desconocido',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Onda.ui(14, color: Onda.text2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          tooltip: saved ? 'Quitar de favoritos' : 'Guardar en favoritos',
          onPressed: songId == null
              ? null
              : () => ref.read(playerActionsProvider).toggleFavorite(songId),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, a) => ScaleTransition(scale: a, child: child),
            child: Icon(
              saved ? Icons.check_rounded : Icons.add_rounded,
              key: ValueKey(saved),
              size: 24,
              color: saved ? Onda.accent : const Color(0xA6F4F2EE),
            ),
          ),
        ),
      ],
    );
  }
}

/// 4px seek bar (8px touch padding) filled with the album's vivid color.
class _ProgressBar extends ConsumerStatefulWidget {
  final Color color;

  const _ProgressBar({required this.color});

  @override
  ConsumerState<_ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends ConsumerState<_ProgressBar> {
  double? _dragRatio;

  void _update(Offset local, double width) {
    setState(() => _dragRatio = (local.dx / width).clamp(0.0, 1.0));
  }

  void _commit(Duration total) {
    final r = _dragRatio;
    if (r == null) return;
    ref
        .read(playerActionsProvider)
        .seek(Duration(milliseconds: (r * total.inMilliseconds).round()));
    setState(() => _dragRatio = null);
  }

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(positionProvider).asData?.value ?? Duration.zero;
    final total = ref.watch(durationProvider).asData?.value ?? Duration.zero;
    final totalMs = total.inMilliseconds;
    final liveRatio =
        totalMs > 0 ? (position.inMilliseconds / totalMs).clamp(0.0, 1.0) : 0.0;
    final ratio = _dragRatio ?? liveRatio;
    final shown = Duration(milliseconds: (ratio * totalMs).round());
    final dragging = _dragRatio != null;

    return Column(
      children: [
        LayoutBuilder(builder: (context, c) {
          final w = c.maxWidth;
          return Semantics(
            slider: true,
            label: 'Progreso de la canción',
            value: formatMinSec(shown),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => _update(d.localPosition, w),
              onTapUp: (_) => _commit(total),
              // A tap that turns into a drag is cancelled first; the drag
              // re-sets the ratio. Any other cancel must not freeze the bar.
              onTapCancel: () => setState(() => _dragRatio = null),
              onHorizontalDragStart: (d) => _update(d.localPosition, w),
              onHorizontalDragUpdate: (d) => _update(d.localPosition, w),
              onHorizontalDragEnd: (_) => _commit(total),
              onHorizontalDragCancel: () => setState(() => _dragRatio = null),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: dragging ? 6 : 4,
                  decoration: BoxDecoration(
                    color: Onda.track,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: ratio,
                    heightFactor: 1,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatMinSec(shown), style: _timeStyle),
            Text('-${formatMinSec(total - shown)}', style: _timeStyle),
          ],
        ),
      ],
    );
  }

  static final _timeStyle = Onda.mono(10.5,
      weight: FontWeight.w400, tracking: 0, color: const Color(0x73F4F2EE));
}

class _Controls extends ConsumerWidget {
  const _Controls();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(isPlayingProvider);
    final shuffle = ref.watch(shuffleModeProvider).asData?.value ==
        AudioServiceShuffleMode.all;
    final repeat =
        ref.watch(repeatModeProvider).asData?.value ?? AudioServiceRepeatMode.none;
    final actions = ref.read(playerActionsProvider);
    const dim = Color(0xBFF4F2EE);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _IconControl(
          icon: Icons.shuffle_rounded,
          label: shuffle ? 'Desactivar aleatorio' : 'Activar aleatorio',
          color: shuffle ? Onda.accent : dim,
          size: 22,
          active: shuffle,
          onTap: actions.toggleShuffle,
        ),
        _IconControl(
          icon: Icons.skip_previous_rounded,
          label: 'Anterior',
          color: Onda.text,
          size: 34,
          box: 44,
          onTap: actions.skipToPrevious,
        ),
        Semantics(
          button: true,
          label: isPlaying ? 'Pausar' : 'Reproducir',
          child: Material(
            color: Onda.text,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: actions.togglePlayPause,
              child: SizedBox(
                width: 70,
                height: 70,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    key: ValueKey(isPlaying),
                    size: 38,
                    color: Onda.onAccent,
                  ),
                ),
              ),
            ),
          ),
        ),
        _IconControl(
          icon: Icons.skip_next_rounded,
          label: 'Siguiente',
          color: Onda.text,
          size: 34,
          box: 44,
          onTap: actions.skipToNext,
        ),
        _IconControl(
          icon: repeat == AudioServiceRepeatMode.one
              ? Icons.repeat_one_rounded
              : Icons.repeat_rounded,
          label: switch (repeat) {
            AudioServiceRepeatMode.none => 'Repetir todo',
            AudioServiceRepeatMode.one => 'Desactivar repetición',
            _ => 'Repetir una canción',
          },
          color: repeat == AudioServiceRepeatMode.none ? dim : Onda.accent,
          size: 22,
          active: repeat != AudioServiceRepeatMode.none,
          onTap: actions.cycleRepeatMode,
        ),
      ],
    );
  }
}

class _IconControl extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double size;
  final double box;
  final bool active;
  final VoidCallback onTap;

  const _IconControl({
    required this.icon,
    required this.label,
    required this.color,
    required this.size,
    required this.onTap,
    this.box = 34,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: box * 0.75,
        child: SizedBox(
          width: box,
          height: box + 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: size, color: color),
              // Small dot marks an active toggle (shuffle / repeat).
              if (active)
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                )
              else
                const SizedBox(height: 7),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onDevice;
  final VoidCallback onShare;
  final VoidCallback onQueue;

  const _Footer({
    required this.onDevice,
    required this.onShare,
    required this.onQueue,
  });

  @override
  Widget build(BuildContext context) {
    Widget link(String text, VoidCallback onTap, {Color color = const Color(0x8CF4F2EE)}) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          child: Text(text, style: Onda.mono(10, color: color)),
        ),
      );
    }

    return Row(
      children: [
        link('ESTE TELÉFONO', onDevice, color: Onda.success),
        const Spacer(),
        link('COMPARTIR', onShare),
        const SizedBox(width: 20),
        link('COLA', onQueue),
      ],
    );
  }
}
