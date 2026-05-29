/// Formatters de date en français, sans dépendre de `intl`.
///
/// Pour Sprint 1, on évite d'ajouter `intl` + `flutter_localizations` :
/// les besoins sont limités et `intl` ajoute ~500 ko au binaire.
class FrDate {
  FrDate._();

  static const List<String> _monthsShort = [
    'janv.',
    'févr.',
    'mars',
    'avr.',
    'mai',
    'juin',
    'juil.',
    'août',
    'sept.',
    'oct.',
    'nov.',
    'déc.',
  ];

  static const List<String> _monthsLong = [
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre',
  ];

  static const List<String> _daysLong = [
    'lundi',
    'mardi',
    'mercredi',
    'jeudi',
    'vendredi',
    'samedi',
    'dimanche',
  ];

  static const List<String> _daysShort = [
    'lun.',
    'mar.',
    'mer.',
    'jeu.',
    'ven.',
    'sam.',
    'dim.',
  ];

  /// Exemple : `12 mai 2026`.
  static String shortDate(DateTime d) =>
      '${d.day} ${_monthsShort[d.month - 1]} ${d.year}';

  /// Exemple : `12 mai`.
  static String dayMonth(DateTime d) => '${d.day} ${_monthsShort[d.month - 1]}';

  /// Exemple : `lundi 12 mai`.
  static String longDay(DateTime d) =>
      '${_daysLong[d.weekday - 1]} ${d.day} ${_monthsShort[d.month - 1]}';

  /// Exemple : `lun.`.
  static String shortDayName(DateTime d) => _daysShort[d.weekday - 1];

  /// Exemple : `mai 2026`.
  static String monthYear(DateTime d) =>
      '${_monthsLong[d.month - 1]} ${d.year}';

  /// Exemple : `08:30`.
  static String hourMinute(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  /// Capitalise la première lettre.
  static String capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
