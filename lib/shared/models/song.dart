import 'package:isar_community/isar.dart';

part 'song.g.dart';

@collection
class Song {
  Id id = Isar.autoIncrement;

  String title;

  int? artistId;
  String? artistName;

  int? albumId;
  String? albumName;

  int? audioId;
  int? duration;
  String? uri;
  int? trackNumber;
  String? genre;
  int? year;
  String? artworkPath;
  DateTime? dateAdded;
  bool isFavorite;

  Song({
    required this.title,
    this.artistId,
    this.artistName,
    this.albumId,
    this.albumName,
    this.audioId,
    this.duration,
    this.uri,
    this.trackNumber,
    this.genre,
    this.year,
    this.artworkPath,
    this.dateAdded,
    this.isFavorite = false,
  });
}
