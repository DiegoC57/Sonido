import 'package:isar_community/isar.dart';

part 'playback_info.g.dart';

@collection
class PlaybackInfo {
  Id id = Isar.autoIncrement;

  String? lastSongUri;
  String? lastSongTitle;
  String? lastSongArtist;
  int? lastPositionMs;
  int? lastSongAudioId;
  bool shuffleEnabled;
  String repeatMode;

  PlaybackInfo({
    this.lastSongUri,
    this.lastSongTitle,
    this.lastSongArtist,
    this.lastPositionMs,
    this.lastSongAudioId,
    this.shuffleEnabled = false,
    this.repeatMode = 'none',
  });
}
