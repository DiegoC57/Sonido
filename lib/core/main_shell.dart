import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/player/widgets/mini_player.dart';
import '../shared/providers/player_provider.dart';

final _hasMediaProvider = StreamProvider<bool>((ref) {
  final handler = ref.watch(audioHandlerProvider).asData?.value;
  if (handler == null) return Stream.value(false);
  return handler.mediaItem.stream.map((item) => item != null);
});

class ScreenWithMiniPlayer extends ConsumerWidget {
  final Widget child;

  const ScreenWithMiniPlayer({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasMedia = ref.watch(_hasMediaProvider).asData?.value ?? false;
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
