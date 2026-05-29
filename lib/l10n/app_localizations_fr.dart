// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Scolar';

  @override
  String get splashTagline => 'Ta scolarité dans la poche';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingStart => 'Commencer';

  @override
  String get onboardingGuest => 'Continuer comme invité';

  @override
  String get authLoginTitle => 'Bon retour !';

  @override
  String get authLoginSubtitle =>
      'Connecte-toi pour accéder à tes notes et à ton emploi du temps.';

  @override
  String get authEmailLabel => 'EMAIL';

  @override
  String get authPasswordLabel => 'MOT DE PASSE';

  @override
  String get authSubmitLogin => 'Se connecter';

  @override
  String get authSwitchToRegister => 'Pas encore de compte ? S\'inscrire';

  @override
  String get authRegisterTitle => 'Créer un compte';

  @override
  String get authSubmitRegister => 'Créer mon compte';

  @override
  String get authFullNameLabel => 'NOM COMPLET';

  @override
  String get authPasswordHelp => '6 caractères minimum';

  @override
  String get validationEmailRequired => 'Email requis';

  @override
  String get validationEmailInvalid => 'Email invalide';

  @override
  String get validationPasswordRequired => 'Mot de passe requis';

  @override
  String get validationPasswordTooShort => 'Minimum 6 caractères';

  @override
  String get validationNameRequired => 'Nom requis';

  @override
  String get homeGreeting => 'Bonjour,';

  @override
  String get homeWeekTitle => 'Ta semaine\nen un coup d\'œil.';

  @override
  String get homeStatAverage => 'Moyenne\ngénérale';

  @override
  String get homeStatCoursesToday => 'Cours\naujourd\'hui';

  @override
  String get homeStatHomeworks => 'Devoirs à\nrendre';

  @override
  String get homeUpcomingCourses => 'Prochains cours';

  @override
  String get homeMySubjects => 'Mes matières';

  @override
  String get homeSeeAll => 'Voir tout';

  @override
  String get homeNoMoreCoursesToday => 'Pas d\'autre cours aujourd\'hui.';

  @override
  String get notesTitle => 'Mes notes';

  @override
  String get notesOverallAverage => 'Moyenne générale';

  @override
  String get notesSubjectsSection => 'Matières';

  @override
  String get notesGradesSection => 'Notes du trimestre';

  @override
  String get notesNoGrades => 'Aucune note pour le moment.';

  @override
  String get notesAverageOver20 => '/ 20 — moyenne du trimestre';

  @override
  String get scheduleTitle => 'Emploi du temps';

  @override
  String get scheduleNoCourses => 'Pas de cours.';

  @override
  String get scheduleOngoing => 'EN COURS';

  @override
  String get homeworksTitle => 'Mes devoirs';

  @override
  String get homeworksEmpty => 'Aucun devoir à rendre.';

  @override
  String get homeworksDueToday => 'Pour aujourd\'hui';

  @override
  String get homeworksDueTomorrow => 'Pour demain';

  @override
  String get homeworksMarkDone => 'Marquer comme fait';

  @override
  String get homeworksMarkUndone => 'Marquer comme non fait';

  @override
  String get profileTitle => 'Mon profil';

  @override
  String get profileClassLabel => 'Classe';

  @override
  String get profileSchoolLabel => 'Établissement';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileLogout => 'Se déconnecter';

  @override
  String get profileLogoutConfirmTitle => 'Se déconnecter ?';

  @override
  String get profileLogoutConfirmBody =>
      'Tu devras te reconnecter pour accéder à tes notes et à ton emploi du temps.';

  @override
  String get profileLogoutCancel => 'Annuler';

  @override
  String get profileNotConnected => 'Non connecté';

  @override
  String get updateRequiredTitle => 'Mise à jour requise';

  @override
  String get updateRequiredBody =>
      'Une nouvelle version de Scolar est disponible. Mets l\'application à jour pour continuer.';

  @override
  String get updateRequiredAction => 'Mettre à jour';

  @override
  String get errorTimeout =>
      'La connexion est lente. Vérifie ton réseau et réessaie.';

  @override
  String get errorNetwork => 'Pas de connexion internet.';

  @override
  String get errorUnauthorized => 'Session expirée. Reconnecte-toi.';

  @override
  String get errorForbidden => 'Tu n\'as pas accès à cette ressource.';

  @override
  String get errorNotFound => 'Ressource introuvable.';

  @override
  String get errorServer =>
      'Le serveur rencontre un problème. Réessaie dans quelques minutes.';

  @override
  String get errorUnknown => 'Une erreur inattendue est survenue.';
}
