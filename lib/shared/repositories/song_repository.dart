import 'dart:isolate';
import 'package:isar_community/isar.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../models/song.dart';

class SongRepository {
  final OnAudioQuery _audioQuery;
  final Isar _isar;

  SongRepository({
    required OnAudioQuery audioQuery,
    required Isar isar,
  })  : _audioQuery = audioQuery,
        _isar = isar;

  Future<List<Song>> getAll({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _isar.songs.where().findAll();
      if (cached.isNotEmpty) return cached;
    }

    final hasPermission = await _audioQuery.permissionsStatus();
    if (!hasPermission) {
      final granted = await _audioQuery.permissionsRequest();
      if (!granted) return [];
    }

    final songModels = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
    );

    final songs = await Isolate.run(() => _mapSongModels(songModels));

    await _isar.writeTxn(() async {
      await _isar.songs.clear();
      await _isar.songs.putAll(songs);
    });

    return songs;
  }

  Future<Map<String, List<Song>>> getByAlbum({
    bool forceRefresh = false,
  }) async {
    final songs = await getAll(forceRefresh: forceRefresh);
    final map = <String, List<Song>>{};
    for (final song in songs) {
      final key = song.albumName ?? 'Unknown Album';
      map.putIfAbsent(key, () => []).add(song);
    }
    return map;
  }

  Future<Map<String, List<Song>>> getByArtist({
    bool forceRefresh = false,
  }) async {
    final songs = await getAll(forceRefresh: forceRefresh);
    final map = <String, List<Song>>{};
    for (final song in songs) {
      final key = song.artistName ?? 'Unknown Artist';
      map.putIfAbsent(key, () => []).add(song);
    }
    return map;
  }

  Future<Map<String, List<Song>>> getByFolder({
    bool forceRefresh = false,
  }) async {
    final songs = await getAll(forceRefresh: forceRefresh);
    final map = <String, List<Song>>{};
    for (final song in songs) {
      final folder = _extractFolder(song.uri);
      if (folder != null) {
        map.putIfAbsent(folder, () => []).add(song);
      }
    }
    return map;
  }

  String? _extractFolder(String? uri) {
    if (uri == null || uri.isEmpty) return null;
    try {
      final segments = Uri.parse(uri).pathSegments;
      if (segments.length >= 2) {
        return segments[segments.length - 2];
      }
      return '/';
    } catch (_) {
      return null;
    }
  }

  static List<Song> _mapSongModels(List<SongModel> songModels) {
    return songModels.map((s) {
      final uri = s.uri ?? s.data;
      return Song(
        title: s.title,
        artistId: s.artistId,
        artistName: s.artist,
        albumId: s.albumId,
        albumName: s.album,
        audioId: s.id,
        duration: s.duration,
        uri: uri,
        trackNumber: s.track,
        genre: s.genre,
        dateAdded: s.dateAdded != null
            ? DateTime.fromMillisecondsSinceEpoch(s.dateAdded! * 1000)
            : null,
      );
    }).toList();
  }
}
