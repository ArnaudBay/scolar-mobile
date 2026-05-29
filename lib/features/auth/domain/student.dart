/// Modèle métier élève — minimal, à enrichir avec le contrat backend.
class Student {
  const Student({
    required this.id,
    required this.fullName,
    required this.email,
    this.classLabel,
    this.schoolName,
    this.avatarUrl,
  });

  final String id;
  final String fullName;
  final String email;
  final String? classLabel;
  final String? schoolName;
  final String? avatarUrl;

  String get firstName => fullName.split(' ').first;
}
