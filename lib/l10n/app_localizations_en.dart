// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Scolar';

  @override
  String get splashTagline => 'Your school in your pocket';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingGuest => 'Continue as guest';

  @override
  String get authLoginTitle => 'Welcome back!';

  @override
  String get authLoginSubtitle => 'Sign in to access your grades and schedule.';

  @override
  String get authEmailLabel => 'EMAIL';

  @override
  String get authPasswordLabel => 'PASSWORD';

  @override
  String get authSubmitLogin => 'Sign in';

  @override
  String get authSwitchToRegister => 'No account yet? Sign up';

  @override
  String get authRegisterTitle => 'Create an account';

  @override
  String get authSubmitRegister => 'Create my account';

  @override
  String get authFullNameLabel => 'FULL NAME';

  @override
  String get authPasswordHelp => '6 characters minimum';

  @override
  String get validationEmailRequired => 'Email required';

  @override
  String get validationEmailInvalid => 'Invalid email';

  @override
  String get validationPasswordRequired => 'Password required';

  @override
  String get validationPasswordTooShort => 'At least 6 characters';

  @override
  String get validationNameRequired => 'Name required';

  @override
  String get homeGreeting => 'Hi,';

  @override
  String get homeWeekTitle => 'Your week\nat a glance.';

  @override
  String get homeStatAverage => 'Overall\naverage';

  @override
  String get homeStatCoursesToday => 'Courses\ntoday';

  @override
  String get homeStatHomeworks => 'Homeworks\nto do';

  @override
  String get homeUpcomingCourses => 'Upcoming courses';

  @override
  String get homeMySubjects => 'My subjects';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeNoMoreCoursesToday => 'No more courses today.';

  @override
  String get notesTitle => 'My grades';

  @override
  String get notesOverallAverage => 'Overall average';

  @override
  String get notesSubjectsSection => 'Subjects';

  @override
  String get notesGradesSection => 'Grades this term';

  @override
  String get notesNoGrades => 'No grades yet.';

  @override
  String get notesAverageOver20 => '/ 20 — term average';

  @override
  String get scheduleTitle => 'Schedule';

  @override
  String get scheduleNoCourses => 'No courses.';

  @override
  String get scheduleOngoing => 'ONGOING';

  @override
  String get homeworksTitle => 'My homeworks';

  @override
  String get homeworksEmpty => 'No homework to turn in.';

  @override
  String get homeworksDueToday => 'Due today';

  @override
  String get homeworksDueTomorrow => 'Due tomorrow';

  @override
  String get homeworksMarkDone => 'Mark as done';

  @override
  String get homeworksMarkUndone => 'Mark as undone';

  @override
  String get profileTitle => 'My profile';

  @override
  String get profileClassLabel => 'Class';

  @override
  String get profileSchoolLabel => 'School';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileLogout => 'Sign out';

  @override
  String get profileLogoutConfirmTitle => 'Sign out?';

  @override
  String get profileLogoutConfirmBody =>
      'You\'ll need to sign in again to access your grades and schedule.';

  @override
  String get profileLogoutCancel => 'Cancel';

  @override
  String get profileNotConnected => 'Not signed in';

  @override
  String get updateRequiredTitle => 'Update required';

  @override
  String get updateRequiredBody =>
      'A new version of Scolar is available. Update the app to continue.';

  @override
  String get updateRequiredAction => 'Update';

  @override
  String get errorTimeout =>
      'Connection is slow. Check your network and try again.';

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorUnauthorized => 'Session expired. Sign in again.';

  @override
  String get errorForbidden => 'You don\'t have access to this resource.';

  @override
  String get errorNotFound => 'Resource not found.';

  @override
  String get errorServer =>
      'The server has a problem. Try again in a few minutes.';

  @override
  String get errorUnknown => 'An unexpected error occurred.';
}
