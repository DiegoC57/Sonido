
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../shared/providers/player_provider.dart';
import '../../shared/providers/song_provider.dart';
import '../../shared/theme/app_text_styles.dart';
import '../../shared/utils/duration_formatter.dart';
import 'widgets/queue_sheet.dart';
import 'widgets/player_options_sheet.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  Color _dominantColor = Colors.black;
  double _volumeGestureDelta = 0;
  bool _isExtracting = false;
  int? _lastExtractedId;
  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _extractColor(int audioId) {
    if (_isExtracting) return;
    _isExtracting = true;
    final audioIdCapture = audioId;
    ref.read(dominantColorProvider(audioIdCapture).future).then((color) {
      if (!mounted || _lastExtractedId != audioIdCapture) return;
      setState(() => _dominantColor = color);
      _isExtracting = false;
    }).catchError((_) {
      if (!mounted) return;
      setState(() => _dominantColor = Colors.black);
      _isExtracting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaItem = ref.watch(currentMediaItemProvider).asData?.value;
    final isPlaying = ref.watch(isPlayingProvider);
    final position = ref.watch(positionProvider).asData?.value ?? Duration.zero;
    final duration = ref.watch(durationProvider).asData?.value ?? Duration.zero;
    final shuffleMode = ref.watch(shuffleModeProvider).asData?.value;
    final repeatMode = ref.watch(repeatModeProvider).asData?.value;
    final actions = ref.read(playerActionsProvider);

    final audioId = mediaItem?.extras?['audioId'] as int?;
    if (audioId != null && audioId != _lastExtractedId) {
      _lastExtractedId = audioId;
      _extractColor(audioId);
    }

    ref.listen(currentMediaItemProvider, (prev, next) {
      final item = next.asData?.value;
      final newAudioId = item?.extras?['audioId'] as int?;
      if (newAudioId != null && newAudioId != _lastExtractedId) {
        _lastExtractedId = newAudioId;
        _extractColor(newAudioId);
      }
    });

    if (isPlaying && !_rotationController.isAnimating) {
      _rotationController.repeat();
    } else if (!isPlaying && _rotationController.isAnimating) {
      _rotationController.stop();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 32),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: mediaItem == null
                ? null
                : () => _showOptions(context, mediaItem),
          ),
        ],
      ),
      body: mediaItem == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white54),
                  SizedBox(height: 16),
                  Text(
                    'Cargando...',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1500),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _dominantColor,
                          _dominantColor.withAlpha(200),
                          Color.lerp(_dominantColor, Colors.black, 0.6)!,
                          Colors.black,
                        ],
                        stops: const [0.0, 0.35, 0.75, 1.0],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      _RotatingArtwork(
                        mediaItem: mediaItem,
                        rotationController: _rotationController,
                        onSwipeLeft: () => actions.skipToNext(),
                        onSwipeRight: () => actions.skipToPrevious(),
                        onVolumeChange: (delta) {
                          _volumeGestureDelta += delta;
                          final normalized =
                              (_volumeGestureDelta / 300).clamp(-1.0, 1.0);
                          final volume = (normalized + 1) / 2;
                          actions.setVolume(volume);
                        },
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                key: ValueKey('title_${mediaItem.id}'),
                                mediaItem.title,
                                style: appTitleLarge(),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              mediaItem.artist ?? 'Artista desconocido',
                              style: appSecondary(fontSize: 15, color: Colors.grey.shade400),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 2),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _SeekBar(
                          position: position,
                          duration: duration,
                          dominantColor: _dominantColor,
                          onChanged: (value) => actions.seek(value),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _Controls(
                        isPlaying: isPlaying,
                        shuffleMode:
                            shuffleMode ?? AudioServiceShuffleMode.none,
                        repeatMode:
                            repeatMode ?? AudioServiceRepeatMode.none,
                        dominantColor: _dominantColor,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.cast, color: Colors.grey.shade400),
                              onPressed: () => _showConnect(context),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.share_outlined,
                                      color: Colors.grey.shade400),
                                  onPressed: () => _shareCurrent(mediaItem),
                                ),
                                IconButton(
                                  icon: Icon(Icons.queue_music,
                                      color: Colors.grey.shade400),
                                  onPressed: () => _showQueue(context),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
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
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => PlayerOptionsSheet(mediaItem: mediaItem),
    );
  }

  void _showQueue(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const QueueSheet(),
    );
  }

  void _showConnect(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cast, size: 40, color: Colors.grey),
            SizedBox(height: 12),
            Text('No se encontraron dispositivos', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _shareCurrent(MediaItem mediaItem) {
    SharePlus.instance.share(
      ShareParams(text: '${mediaItem.title} - ${mediaItem.artist ?? ''}'),
    );
  }
}

class _RotatingArtwork extends StatelessWidget {
  final MediaItem mediaItem;
  final AnimationController rotationController;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final ValueChanged<double> onVolumeChange;

  const _RotatingArtwork({
    required this.mediaItem,
    required this.rotationController,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onVolumeChange,
  });

  @override
  Widget build(BuildContext context) {
    final audioId = mediaItem.extras?['audioId'] as int?;
    final size = MediaQuery.of(context).size.width * 0.7;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < -300) {
          onSwipeLeft();
        } else if (details.primaryVelocity! > 300) {
          onSwipeRight();
        }
      },
      onVerticalDragUpdate: (details) {
        onVolumeChange(details.primaryDelta ?? 0);
      },
      child: SizedBox(
        width: size,
        height: size,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: Hero(
            key: ValueKey('artwork_${mediaItem.id}'),
            tag: 'player_artwork',
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade900,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(100),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: AnimatedBuilder(
                animation: rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: rotationController.value * 2 * pi,
                    child: child,
                  );
                },
                child: _ArtworkImage(audioId: audioId),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArtworkImage extends ConsumerWidget {
  final int? audioId;

  const _ArtworkImage({this.audioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (audioId == null) return _defaultArtwork();
    final artworkAsync = ref.watch(artworkProvider(audioId!));
    return artworkAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => _defaultArtwork(),
      data: (bytes) {
        if (bytes == null) return _defaultArtwork();
        return Image.memory(bytes, fit: BoxFit.cover);
      },
    );
  }

  Widget _defaultArtwork() {
    return Container(
      color: Colors.grey.shade800,
      child: Icon(Icons.music_note, size: 60, color: Colors.grey.shade600),
    );
  }
}

class _SeekBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Color dominantColor;
  final ValueChanged<Duration> onChanged;

  const _SeekBar({
    required this.position,
    required this.duration,
    required this.dominantColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final totalMs = duration.inMilliseconds.toDouble();
    final posMs = position.inMilliseconds.toDouble().clamp(0, totalMs);
    final progress = totalMs > 0 ? posMs / totalMs : 0.0;

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: dominantColor.computeLuminance() > 0.5
                ? dominantColor
                : dominantColor.lighten(),
            inactiveTrackColor: Colors.white24,
            thumbColor: Colors.white,
            overlayColor: dominantColor.withAlpha(30),
          ),
          child: Slider(
            value: progress,
            onChanged: (value) {
              onChanged(Duration(milliseconds: (value * totalMs).round()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(position),
                style: appSecondary(fontSize: 12, color: Colors.grey.shade400),
              ),
              Text(
                formatDuration(duration),
                style: appSecondary(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Controls extends StatelessWidget {
  final bool isPlaying;
  final AudioServiceShuffleMode shuffleMode;
  final AudioServiceRepeatMode repeatMode;
  final Color dominantColor;

  const _Controls({
    required this.isPlaying,
    required this.shuffleMode,
    required this.repeatMode,
    required this.dominantColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final actions = ref.read(playerActionsProvider);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ShuffleButton(mode: shuffleMode),
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 38),
                color: Colors.white70,
                onPressed: () => actions.skipToPrevious(),
              ),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: dominantColor.withAlpha(80),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                    color: Colors.black87,
                  ),
                  onPressed: () => actions.togglePlayPause(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, size: 38),
                color: Colors.white70,
                onPressed: () => actions.skipToNext(),
              ),
              _RepeatButton(mode: repeatMode),
            ],
          ),
        );
      },
    );
  }
}

class _ShuffleButton extends StatelessWidget {
  final AudioServiceShuffleMode mode;

  const _ShuffleButton({required this.mode});

  @override
  Widget build(BuildContext context) {
    final enabled = mode == AudioServiceShuffleMode.all;
    return Consumer(
      builder: (context, ref, _) {
        return IconButton(
          icon: Icon(
            Icons.shuffle,
            size: 26,
            color: enabled
                ? Theme.of(context).colorScheme.primary
                : Colors.white54,
          ),
          onPressed: () => ref.read(playerActionsProvider).toggleShuffle(),
        );
      },
    );
  }
}

class _RepeatButton extends StatelessWidget {
  final AudioServiceRepeatMode mode;

  const _RepeatButton({required this.mode});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color? color;
    switch (mode) {
      case AudioServiceRepeatMode.one:
        icon = Icons.repeat_one;
        color = Theme.of(context).colorScheme.primary;
      case AudioServiceRepeatMode.all:
        icon = Icons.repeat;
        color = Theme.of(context).colorScheme.primary;
      default:
        icon = Icons.repeat;
        color = Colors.white54;
    }
    return Consumer(
      builder: (context, ref, _) {
        return IconButton(
          icon: Icon(icon, size: 26, color: color),
          onPressed: () => ref.read(playerActionsProvider).cycleRepeatMode(),
        );
      },
    );
  }
}

extension _ColorExtension on Color {
  Color lighten([double amount = 0.3]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }
}
