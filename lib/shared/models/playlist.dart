import 'package:isar_community/isar.dart';

part 'playlist.g.dart';

@collection
class Playlist {
  Id id = Isar.autoIncrement;

  String name;
  String? description;
  DateTime createdAt;
  List<int>? songIds;

  Playlist({
    required this.name,
    this.description,
    required this.createdAt,
    this.songIds,
  });
}
