import 'package:isar_community/isar.dart';

part 'artist.g.dart';

@collection
class Artist {
  Id id = Isar.autoIncrement;

  String name;

  int? songCount;
  int? albumCount;
  String? artworkPath;

  Artist({
    required this.name,
    this.songCount,
    this.albumCount,
    this.artworkPath,
  });
}
