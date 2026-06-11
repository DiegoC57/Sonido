import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audio_query_provider.dart';
import '../providers/isar_provider.dart';
import 'song_repository.dart';

final songRepositoryProvider = FutureProvider<SongRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  final audioQuery = ref.watch(audioQueryProvider);
  return SongRepository(audioQuery: audioQuery, isar: isar);
});
