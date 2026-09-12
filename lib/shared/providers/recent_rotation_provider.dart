import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import '../models/recent_play.dart';
import 'isar_provider.dart';

const _maxRecentEntries = 30;
const _recentRotationLimit = 10;

final recentRotationProvider =
    AsyncNotifierProvider<RecentRotationNotifier, List<RecentPlay>>(
  RecentRotationNotifier.new,
);

class RecentRotationNotifier extends AsyncNotifier<List<RecentPlay>> {
  @override
  Future<List<RecentPlay>> build() async {
    final isar = await ref.watch(isarProvider.future);
    final entries = await isar.recentPlays
        .where()
        .sortByPlayedAtDesc()
        .limit(_recentRotationLimit)
        .findAll();
    return entries;
  }

  Future<void> recordPlay({
    required String albumKey,
    String? albumName,
    String? artistName,
    int? representativeAudioId,
  }) async {
    final isar = await ref.read(isarProvider.future);
    final entry = RecentPlay(
      albumKey: albumKey,
      albumName: albumName,
      artistName: artistName,
      representativeAudioId: representativeAudioId,
      playedAt: DateTime.now(),
    );

    await isar.writeTxn(() async {
      await isar.recentPlays.putByAlbumKey(entry);
      final all = await isar.recentPlays.where().sortByPlayedAtDesc().findAll();
      if (all.length > _maxRecentEntries) {
        final toRemove = all.skip(_maxRecentEntries).map((e) => e.id).toList();
        await isar.recentPlays.deleteAll(toRemove);
      }
    });

    ref.invalidateSelf();
  }
}
