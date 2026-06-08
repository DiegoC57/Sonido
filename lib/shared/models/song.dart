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

  int? duration;
  String? uri;
  int? trackNumber;
  String? genre;
  int? year;
  String? artworkPath;
  DateTime? dateAdded;

  Song({
    required this.title,
    this.artistId,
    this.artistName,
    this.albumId,
    this.albumName,
    this.duration,
    this.uri,
    this.trackNumber,
    this.genre,
    this.year,
    this.artworkPath,
    this.dateAdded,
  });
}
