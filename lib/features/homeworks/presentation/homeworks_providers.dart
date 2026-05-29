import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../data/dio_homeworks_repository.dart';
import '../data/fake_homeworks_repository.dart';
import '../domain/homeworks_repository.dart';

/// Switch automatique fakes/Dio selon `ApiConfig.useFakes`.
final homeworksRepositoryProvider = Provider<HomeworksRepository>((ref) {
  if (ApiConfig.useFakes) return FakeHomeworksRepository();
  return DioHomeworksRepository(ref.watch(dioClientProvider));
});

/// Liste complète des devoirs (pending + done).
final homeworksProvider = FutureProvider<List<Homework>>((ref) {
  return ref.watch(homeworksRepositoryProvider).fetchAll();
});

/// Nombre de devoirs à rendre (non-done) — utilisé par la carte Home.
final pendingHomeworksCountProvider = FutureProvider<int>((ref) {
  return ref.watch(homeworksRepositoryProvider).countPending();
});
