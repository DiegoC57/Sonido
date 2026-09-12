import 'package:isar_community/isar.dart';

part 'recent_play.g.dart';

@collection
class RecentPlay {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String albumKey;

  String? albumName;
  String? artistName;
  int? representativeAudioId;
  DateTime playedAt;

  RecentPlay({
    required this.albumKey,
    this.albumName,
    this.artistName,
    this.representativeAudioId,
    required this.playedAt,
  });
}
