import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scolar'**
  String get appTitle;

  /// No description provided for @splashTagline.
  ///
  /// In fr, this message translates to:
  /// **'Ta scolarité dans la poche'**
  String get splashTagline;

  /// No description provided for @onboardingSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get onboardingStart;

  /// No description provided for @onboardingGuest.
  ///
  /// In fr, this message translates to:
  /// **'Continuer comme invité'**
  String get onboardingGuest;

  /// No description provided for @authLoginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bon retour !'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connecte-toi pour accéder à tes notes et à ton emploi du temps.'**
  String get authLoginSubtitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'EMAIL'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'MOT DE PASSE'**
  String get authPasswordLabel;

  /// No description provided for @authSubmitLogin.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authSubmitLogin;

  /// No description provided for @authSwitchToRegister.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ? S\'inscrire'**
  String get authSwitchToRegister;

  /// No description provided for @authRegisterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authRegisterTitle;

  /// No description provided for @authSubmitRegister.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get authSubmitRegister;

  /// No description provided for @authFullNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'NOM COMPLET'**
  String get authFullNameLabel;

  /// No description provided for @authPasswordHelp.
  ///
  /// In fr, this message translates to:
  /// **'6 caractères minimum'**
  String get authPasswordHelp;

  /// No description provided for @validationEmailRequired.
  ///
  /// In fr, this message translates to:
  /// **'Email requis'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Email invalide'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe requis'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Minimum 6 caractères'**
  String get validationPasswordTooShort;

  /// No description provided for @validationNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Nom requis'**
  String get validationNameRequired;

  /// No description provided for @homeGreeting.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour,'**
  String get homeGreeting;

  /// No description provided for @homeWeekTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ta semaine\nen un coup d\'œil.'**
  String get homeWeekTitle;

  /// No description provided for @homeStatAverage.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne\ngénérale'**
  String get homeStatAverage;

  /// No description provided for @homeStatCoursesToday.
  ///
  /// In fr, this message translates to:
  /// **'Cours\naujourd\'hui'**
  String get homeStatCoursesToday;

  /// No description provided for @homeStatHomeworks.
  ///
  /// In fr, this message translates to:
  /// **'Devoirs à\nrendre'**
  String get homeStatHomeworks;

  /// No description provided for @homeUpcomingCourses.
  ///
  /// In fr, this message translates to:
  /// **'Prochains cours'**
  String get homeUpcomingCourses;

  /// No description provided for @homeMySubjects.
  ///
  /// In fr, this message translates to:
  /// **'Mes matières'**
  String get homeMySubjects;

  /// No description provided for @homeSeeAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get homeSeeAll;

  /// No description provided for @homeNoMoreCoursesToday.
  ///
  /// In fr, this message translates to:
  /// **'Pas d\'autre cours aujourd\'hui.'**
  String get homeNoMoreCoursesToday;

  /// No description provided for @notesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes notes'**
  String get notesTitle;

  /// No description provided for @notesOverallAverage.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne générale'**
  String get notesOverallAverage;

  /// No description provided for @notesSubjectsSection.
  ///
  /// In fr, this message translates to:
  /// **'Matières'**
  String get notesSubjectsSection;

  /// No description provided for @notesGradesSection.
  ///
  /// In fr, this message translates to:
  /// **'Notes du trimestre'**
  String get notesGradesSection;

  /// No description provided for @notesNoGrades.
  ///
  /// In fr, this message translates to:
  /// **'Aucune note pour le moment.'**
  String get notesNoGrades;

  /// No description provided for @notesAverageOver20.
  ///
  /// In fr, this message translates to:
  /// **'/ 20 — moyenne du trimestre'**
  String get notesAverageOver20;

  /// No description provided for @scheduleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Emploi du temps'**
  String get scheduleTitle;

  /// No description provided for @scheduleNoCourses.
  ///
  /// In fr, this message translates to:
  /// **'Pas de cours.'**
  String get scheduleNoCourses;

  /// No description provided for @scheduleOngoing.
  ///
  /// In fr, this message translates to:
  /// **'EN COURS'**
  String get scheduleOngoing;

  /// No description provided for @homeworksTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes devoirs'**
  String get homeworksTitle;

  /// No description provided for @homeworksEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun devoir à rendre.'**
  String get homeworksEmpty;

  /// No description provided for @homeworksDueToday.
  ///
  /// In fr, this message translates to:
  /// **'Pour aujourd\'hui'**
  String get homeworksDueToday;

  /// No description provided for @homeworksDueTomorrow.
  ///
  /// In fr, this message translates to:
  /// **'Pour demain'**
  String get homeworksDueTomorrow;

  /// No description provided for @homeworksMarkDone.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme fait'**
  String get homeworksMarkDone;

  /// No description provided for @homeworksMarkUndone.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme non fait'**
  String get homeworksMarkUndone;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon profil'**
  String get profileTitle;

  /// No description provided for @profileClassLabel.
  ///
  /// In fr, this message translates to:
  /// **'Classe'**
  String get profileClassLabel;

  /// No description provided for @profileSchoolLabel.
  ///
  /// In fr, this message translates to:
  /// **'Établissement'**
  String get profileSchoolLabel;

  /// No description provided for @profileEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get profileEmailLabel;

  /// No description provided for @profileLogout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter ?'**
  String get profileLogoutConfirmTitle;

  /// No description provided for @profileLogoutConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Tu devras te reconnecter pour accéder à tes notes et à ton emploi du temps.'**
  String get profileLogoutConfirmBody;

  /// No description provided for @profileLogoutCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get profileLogoutCancel;

  /// No description provided for @profileNotConnected.
  ///
  /// In fr, this message translates to:
  /// **'Non connecté'**
  String get profileNotConnected;

  /// No description provided for @updateRequiredTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour requise'**
  String get updateRequiredTitle;

  /// No description provided for @updateRequiredBody.
  ///
  /// In fr, this message translates to:
  /// **'Une nouvelle version de Scolar est disponible. Mets l\'application à jour pour continuer.'**
  String get updateRequiredBody;

  /// No description provided for @updateRequiredAction.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à jour'**
  String get updateRequiredAction;

  /// No description provided for @errorTimeout.
  ///
  /// In fr, this message translates to:
  /// **'La connexion est lente. Vérifie ton réseau et réessaie.'**
  String get errorTimeout;

  /// No description provided for @errorNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion internet.'**
  String get errorNetwork;

  /// No description provided for @errorUnauthorized.
  ///
  /// In fr, this message translates to:
  /// **'Session expirée. Reconnecte-toi.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In fr, this message translates to:
  /// **'Tu n\'as pas accès à cette ressource.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Ressource introuvable.'**
  String get errorNotFound;

  /// No description provided for @errorServer.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur rencontre un problème. Réessaie dans quelques minutes.'**
  String get errorServer;

  /// No description provided for @errorUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur inattendue est survenue.'**
  String get errorUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
