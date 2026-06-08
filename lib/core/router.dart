import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/library/library_screen.dart';
import '../features/player/player_screen.dart';
import '../features/playlist/playlist_detail_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/library',
    routes: [
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: '/player',
        name: 'player',
        builder: (context, state) => const PlayerScreen(),
      ),
      GoRoute(
        path: '/playlist/:id',
        name: 'playlistDetail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PlaylistDetailScreen(playlistId: id);
        },
      ),
    ],
  );
});
