import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import '../../core/utils/isar_init.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  final isar = await initIsar();
  ref.onDispose(() => isar.close());
  return isar;
});
