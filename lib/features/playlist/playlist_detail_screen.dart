import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/main_shell.dart';

class PlaylistDetailScreen extends ConsumerWidget {
  final int playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenWithMiniPlayer(
      child: Scaffold(
        appBar: AppBar(title: const Text('Playlist')),
        body: Center(
          child: Text(
            'Playlist #$playlistId',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
