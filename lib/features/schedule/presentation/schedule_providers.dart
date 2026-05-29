import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../data/dio_schedule_repository.dart';
import '../data/fake_schedule_repository.dart';
import '../domain/schedule_repository.dart';

/// Switch automatique fakes/Dio selon `ApiConfig.useFakes`.
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  if (ApiConfig.useFakes) return FakeScheduleRepository();
  return DioScheduleRepository(ref.watch(dioClientProvider));
});

/// Renvoie le lundi 00h00 (heure locale) de la semaine contenant [date].
DateTime mondayOf(DateTime date) {
  final d = DateTime(date.year, date.month, date.day);
  return d.subtract(Duration(days: d.weekday - 1));
}

/// Lundi de la semaine actuellement affichée par l'écran d'emploi du temps.
final selectedWeekProvider = StateProvider<DateTime>(
  (ref) => mondayOf(DateTime.now()),
);

/// Cours de la semaine sélectionnée.
final weekScheduleProvider = FutureProvider<List<CourseSlot>>((ref) {
  final weekStart = ref.watch(selectedWeekProvider);
  return ref.watch(scheduleRepositoryProvider).fetchWeek(weekStart);
});

/// Cours du jour (sous-ensemble de la semaine courante).
final todayScheduleProvider = FutureProvider<List<CourseSlot>>((ref) async {
  final slots = await ref.watch(weekScheduleProvider.future);
  final now = DateTime.now();
  return slots
      .where(
        (s) =>
            s.start.year == now.year &&
            s.start.month == now.month &&
            s.start.day == now.day,
      )
      .toList(growable: false);
});
