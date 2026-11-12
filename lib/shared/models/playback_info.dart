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

  /// URIs of every track in the play queue (in original, unshuffled order),
  /// so the whole queue — not just the last song — survives an app restart.
  List<String> queueUris;

  /// Index into [queueUris] of the track that was playing.
  int? queueIndex;

  PlaybackInfo({
    this.lastSongUri,
    this.lastSongTitle,
    this.lastSongArtist,
    this.lastPositionMs,
    this.lastSongAudioId,
    this.shuffleEnabled = false,
    this.repeatMode = 'none',
    this.queueUris = const [],
    this.queueIndex,
  });
}
