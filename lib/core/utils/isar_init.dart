import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../shared/models/song.dart';
import '../../shared/models/album.dart';
import '../../shared/models/artist.dart';
import '../../shared/models/playlist.dart';
import '../../shared/models/playback_info.dart';

Future<Isar> initIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [SongSchema, AlbumSchema, ArtistSchema, PlaylistSchema, PlaybackInfoSchema],
    directory: dir.path,
  );
}
