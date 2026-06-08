import 'package:isar_community/isar.dart';

part 'album.g.dart';

@collection
class Album {
  Id id = Isar.autoIncrement;

  String name;

  int? artistId;
  String? artistName;
  int? songCount;
  int? duration;
  String? artworkPath;
  int? year;

  Album({
    required this.name,
    this.artistId,
    this.artistName,
    this.songCount,
    this.duration,
    this.artworkPath,
    this.year,
  });
}
