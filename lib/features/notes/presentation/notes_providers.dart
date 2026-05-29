import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../data/dio_notes_repository.dart';
import '../data/fake_notes_repository.dart';
import '../domain/notes_repository.dart';

/// Switch automatique fakes/Dio selon `ApiConfig.useFakes`.
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  if (ApiConfig.useFakes) return FakeNotesRepository();
  return DioNotesRepository(ref.watch(dioClientProvider));
});

/// Liste des matières de l'élève courant.
final subjectsProvider = FutureProvider<List<Subject>>((ref) {
  return ref.watch(notesRepositoryProvider).fetchSubjects();
});

/// Moyenne générale de l'élève courant.
final overallAverageProvider = FutureProvider<double>((ref) {
  return ref.watch(notesRepositoryProvider).fetchOverallAverage();
});

/// Notes détaillées pour une matière.
final gradesForSubjectProvider = FutureProvider.family<List<Grade>, String>(
  (ref, subjectId) => ref.watch(notesRepositoryProvider).fetchGrades(subjectId),
);
