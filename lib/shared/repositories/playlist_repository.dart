import 'package:isar_community/isar.dart';
import '../models/playlist.dart';

class PlaylistRepository {
  final Isar _isar;

  PlaylistRepository({required Isar isar}) : _isar = isar;

  Future<List<Playlist>> getAll() {
    return _isar.playlists.where().findAll();
  }

  Future<Playlist?> getById(int id) {
    return _isar.playlists.get(id);
  }

  Future<Playlist> create(String name) async {
    final playlist = Playlist(name: name, createdAt: DateTime.now(), songIds: []);
    await _isar.writeTxn(() async {
      await _isar.playlists.put(playlist);
    });
    return playlist;
  }

  Future<void> addSong(int playlistId, int songId) async {
    await _isar.writeTxn(() async {
      final playlist = await _isar.playlists.get(playlistId);
      if (playlist == null) return;
      final songIds = List<int>.from(playlist.songIds ?? []);
      if (!songIds.contains(songId)) {
        songIds.add(songId);
        playlist.songIds = songIds;
        await _isar.playlists.put(playlist);
      }
    });
  }

  Future<void> removeSong(int playlistId, int songId) async {
    await _isar.writeTxn(() async {
      final playlist = await _isar.playlists.get(playlistId);
      if (playlist == null) return;
      final songIds = List<int>.from(playlist.songIds ?? []);
      songIds.remove(songId);
      playlist.songIds = songIds;
      await _isar.playlists.put(playlist);
    });
  }
}
