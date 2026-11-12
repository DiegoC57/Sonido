import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar_community/isar.dart';
import 'core/router.dart';
import 'shared/providers/isar_provider.dart';
import 'shared/providers/player_provider.dart';
import 'shared/models/playback_info.dart';
import 'shared/models/song.dart';

const kSpotifyGreen = Color(0xFF1DB954);

/// Montserrat for headline/title roles, Inter for everything else.
TextTheme _buildTextTheme(TextTheme base) {
  final interTheme = GoogleFonts.interTextTheme(base);
  final montserratTheme = GoogleFonts.montserratTextTheme(base);
  return interTheme.copyWith(
    headlineLarge: montserratTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
    headlineMedium: montserratTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
    headlineSmall: montserratTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    titleLarge: montserratTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    titleMedium: montserratTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SonidoApp(),
    ),
  );
}

class SonidoApp extends ConsumerStatefulWidget {
  const SonidoApp({super.key});

  @override
  ConsumerState<SonidoApp> createState() => _SonidoAppState();
}

class _SonidoAppState extends ConsumerState<SonidoApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioHandlerProvider.future).then((_) {
        restorePlaybackState();
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      savePlaybackState();
    }
  }

  Future<void> restorePlaybackState() async {
    try {
      final handler = await ref.read(audioHandlerProvider.future);
      final isar = await ref.read(isarProvider.future);
      final saved = await isar.playbackInfos.get(1);
      if (saved == null || saved.lastSongUri == null) return;

      final position = Duration(milliseconds: saved.lastPositionMs ?? 0);

      // Rebuild the full queue from the library so next/previous keep
      // working after the app was closed. Tracks deleted from the device
      // since the last session are skipped.
      final songs = await isar.songs.where().findAll();
      final byUri = {
        for (final s in songs)
          if (s.uri != null) s.uri!: s,
      };
      final items = <MediaItem>[];
      for (final uri in saved.queueUris) {
        final song = byUri[uri];
        if (song != null) items.add(song.toMediaItem());
      }

      // Prefer the saved index (correct even if a song appears twice); fall
      // back to looking the URI up if songs were removed from the library.
      final savedIndex = saved.queueIndex;
      var index = (savedIndex != null &&
              items.length == saved.queueUris.length &&
              savedIndex >= 0 &&
              savedIndex < items.length &&
              items[savedIndex].id == saved.lastSongUri)
          ? savedIndex
          : items.indexWhere((i) => i.id == saved.lastSongUri);
      if (index < 0) {
        // Old save format (single song) or the queue no longer contains it.
        final last = byUri[saved.lastSongUri!];
        if (last == null) return;
        items
          ..clear()
          ..add(last.toMediaItem());
        index = 0;
      }

      await handler.setQueue(
        items,
        initialIndex: index,
        initialPosition: position,
      );

      if (saved.shuffleEnabled) {
        await handler.setShuffleMode(AudioServiceShuffleMode.all);
      }
      switch (saved.repeatMode) {
        case 'one':
          await handler.setRepeatMode(AudioServiceRepeatMode.one);
        case 'all':
          await handler.setRepeatMode(AudioServiceRepeatMode.all);
        default:
          await handler.setRepeatMode(AudioServiceRepeatMode.none);
      }
    } catch (_) {}
  }

  Future<void> savePlaybackState() async {
    try {
      final handler = ref.read(audioHandlerProvider).asData?.value;
      if (handler == null) return;
      final item = handler.mediaItem.value;
      if (item == null) return;

      final isar = await ref.read(isarProvider.future);
      final existing = await isar.playbackInfos.get(1);
      final info = existing ?? PlaybackInfo();
      info.lastSongUri = item.id;
      info.lastSongTitle = item.title;
      info.lastSongArtist = item.artist;
      info.lastPositionMs = handler.player.position.inMilliseconds;
      info.queueUris = handler.currentQueue.map((i) => i.id).toList();
      info.queueIndex = handler.currentQueueIndex;
      info.shuffleEnabled =
          handler.shuffleMode.value == AudioServiceShuffleMode.all;
      info.repeatMode = handler.repeatMode.value.name;

      await isar.writeTxn(() async {
        await isar.playbackInfos.put(info);
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(audioHandlerProvider, (prev, next) {
      if (next is AsyncData) {
        _startPeriodicSave();
      }
    });

    final router = ref.watch(routerProvider);
    final isarAsync = ref.watch(isarProvider);

    return isarAsync.when(
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error al iniciar: $error')),
        ),
      ),
      loading: () => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Inicializando...'),
              ],
            ),
          ),
        ),
      ),
      data: (_) => MaterialApp.router(
        title: 'Sonido',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: kSpotifyGreen,
            brightness: Brightness.dark,
          ).copyWith(primary: kSpotifyGreen, surface: Colors.black, surfaceTint: Colors.black),
          scaffoldBackgroundColor: Colors.black,
          canvasColor: Colors.black,
          useMaterial3: true,
          brightness: Brightness.dark,
          textTheme: _buildTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  bool _periodicSaveStarted = false;

  void _startPeriodicSave() {
    if (_periodicSaveStarted) return;
    _periodicSaveStarted = true;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 15));
      if (!mounted) return false;
      try {
        final handler = ref.read(audioHandlerProvider).asData?.value;
        if (handler != null && handler.playbackState.value.playing) {
          await savePlaybackState();
        }
      } catch (_) {}
      return true;
    });
  }
}
