import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'main_shell.dart';
import '../features/home/home_screen.dart';
import '../features/search/search_screen.dart';
import '../features/library/library_screen.dart';
import '../features/player/player_screen.dart';
import '../features/album/album_screen.dart';
import '../features/playlist/playlist_detail_screen.dart';
import '../shared/theme/onda.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
                routes: [_albumRoute()],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const SearchScreen(),
                routes: [_albumRoute()],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                name: 'library',
                builder: (context, state) => const LibraryScreen(),
                routes: [_albumRoute()],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/player',
        name: 'player',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PlayerScreen(),
          transitionDuration: Onda.sheetDuration,
          reverseTransitionDuration: const Duration(milliseconds: 320),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Onda.sheetCurve,
              reverseCurve: Curves.easeInCubic,
            );
            return SlideTransition(
              position: Tween(begin: const Offset(0, 1.05), end: Offset.zero)
                  .animate(curved),
              child: child,
            );
          },
        ),
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

GoRoute _albumRoute() => GoRoute(
      path: 'album',
      builder: (context, state) =>
          AlbumScreen(albumName: state.uri.queryParameters['name'] ?? ''),
    );

/// Opens the album screen inside the current tab, so the tab bar and mini
/// player stay visible underneath (the "overlay" layer of the Onda spec).
void openAlbum(BuildContext context, String albumName) {
  final segments = GoRouterState.of(context).uri.pathSegments;
  final base = segments.isEmpty ? 'home' : segments.first;
  final tab = const {'home', 'search', 'library'}.contains(base) ? base : 'home';
  context.push('/$tab/album?name=${Uri.encodeQueryComponent(albumName)}');
}
