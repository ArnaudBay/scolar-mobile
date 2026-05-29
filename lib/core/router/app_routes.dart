/// Constantes centralisées des chemins de routes Scolar.
///
/// Ne JAMAIS coder un chemin en dur ailleurs dans l'app : importer cette
/// classe et utiliser ses constantes (`AppRoutes.home`, etc.).
class AppRoutes {
  AppRoutes._();

  // ─── Bootstrap / public ────────────────────────────────────────────────
  static const String splash = '/splash';
  static const String updateRequired = '/update-required';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  // ─── Private (élève authentifié) ───────────────────────────────────────
  static const String home = '/home';
  static const String notes = '/notes';
  static const String noteDetail = '/notes/:subjectId';
  static const String schedule = '/schedule';
  static const String homeworks = '/homeworks';
  static const String profile = '/profile';

  // ─── Helpers ───────────────────────────────────────────────────────────
  static String noteDetailFor(String subjectId) => '/notes/$subjectId';
}
