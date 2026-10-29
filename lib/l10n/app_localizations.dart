import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
    Locale('ca'),
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Reservations App'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enterName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountPrompt;

  /// No description provided for @haveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccountPrompt;

  /// No description provided for @validationEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get validationEnterName;

  /// No description provided for @validationEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get validationEnterEmail;

  /// No description provided for @validationValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validationValidEmail;

  /// No description provided for @validationEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get validationEnterPassword;

  /// No description provided for @validationPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validationPasswordLength;

  /// No description provided for @enterEmailToResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email to reset password'**
  String get enterEmailToResetPassword;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent!'**
  String get passwordResetEmailSent;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email address is not valid.'**
  String get authInvalidEmail;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get authInvalidCredentials;

  /// No description provided for @authEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists for this email.'**
  String get authEmailAlreadyInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak.'**
  String get authWeakPassword;

  /// No description provided for @authTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get authTooManyRequests;

  /// No description provided for @authNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection and try again.'**
  String get authNetworkError;

  /// No description provided for @authRequiresRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'Please log in again before doing this.'**
  String get authRequiresRecentLogin;

  /// No description provided for @authUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get authUserDisabled;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @newReservation.
  ///
  /// In en, this message translates to:
  /// **'New reservation'**
  String get newReservation;

  /// No description provided for @myReservations.
  ///
  /// In en, this message translates to:
  /// **'My reservations'**
  String get myReservations;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User profile'**
  String get userProfile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get languageAutomatic;

  /// No description provided for @profileId.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get profileId;

  /// No description provided for @profileCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get profileCreated;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// No description provided for @deleteUserWarning.
  ///
  /// In en, this message translates to:
  /// **'This action will delete your user and all reservations, do you want to continue?'**
  String get deleteUserWarning;

  /// No description provided for @couldNotFindUser.
  ///
  /// In en, this message translates to:
  /// **'Could not find current user!'**
  String get couldNotFindUser;

  /// No description provided for @dialogCareful.
  ///
  /// In en, this message translates to:
  /// **'Careful!'**
  String get dialogCareful;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT'**
  String get submit;

  /// No description provided for @reservationCreated.
  ///
  /// In en, this message translates to:
  /// **'Time slot successfully reserved!'**
  String get reservationCreated;

  /// No description provided for @reservationCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create reservation'**
  String get reservationCreateFailed;

  /// No description provided for @reservationLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please login to make a reservation'**
  String get reservationLoginRequired;

  /// No description provided for @reservationEqualTimes.
  ///
  /// In en, this message translates to:
  /// **'Start and end times should not be equal!'**
  String get reservationEqualTimes;

  /// No description provided for @reservationTooMany.
  ///
  /// In en, this message translates to:
  /// **'You can\'t have more than 5 active reservations'**
  String get reservationTooMany;

  /// No description provided for @reservationSlotUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Selected time slot is not available'**
  String get reservationSlotUnavailable;

  /// No description provided for @noTablesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tables available'**
  String get noTablesAvailable;

  /// No description provided for @noReservedSlots.
  ///
  /// In en, this message translates to:
  /// **'No reserved slots'**
  String get noReservedSlots;

  /// No description provided for @unknownTable.
  ///
  /// In en, this message translates to:
  /// **'Unknown Table'**
  String get unknownTable;

  /// No description provided for @loadingGames.
  ///
  /// In en, this message translates to:
  /// **'Loading games...'**
  String get loadingGames;

  /// No description provided for @selectGameSystem.
  ///
  /// In en, this message translates to:
  /// **'Select a game system'**
  String get selectGameSystem;

  /// No description provided for @unableToLoadGames.
  ///
  /// In en, this message translates to:
  /// **'Unable to load games'**
  String get unableToLoadGames;

  /// No description provided for @retryLoadingGames.
  ///
  /// In en, this message translates to:
  /// **'Retry loading games'**
  String get retryLoadingGames;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin panel'**
  String get adminPanel;

  /// No description provided for @adminTables.
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get adminTables;

  /// No description provided for @adminGames.
  ///
  /// In en, this message translates to:
  /// **'Game systems'**
  String get adminGames;

  /// No description provided for @adminReservations.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get adminReservations;

  /// No description provided for @adminAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access to this page'**
  String get adminAccessDenied;

  /// No description provided for @backToApp.
  ///
  /// In en, this message translates to:
  /// **'Back to the app'**
  String get backToApp;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationPositiveNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number greater than 0'**
  String get validationPositiveNumber;

  /// No description provided for @addTable.
  ///
  /// In en, this message translates to:
  /// **'Add table'**
  String get addTable;

  /// No description provided for @editTable.
  ///
  /// In en, this message translates to:
  /// **'Edit table'**
  String get editTable;

  /// No description provided for @tableName.
  ///
  /// In en, this message translates to:
  /// **'Table name'**
  String get tableName;

  /// No description provided for @tableLength.
  ///
  /// In en, this message translates to:
  /// **'Length (cm)'**
  String get tableLength;

  /// No description provided for @tableWidth.
  ///
  /// In en, this message translates to:
  /// **'Width (cm)'**
  String get tableWidth;

  /// No description provided for @noTables.
  ///
  /// In en, this message translates to:
  /// **'There are no tables yet'**
  String get noTables;

  /// No description provided for @deleteTableWarning.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{tableName}\" and all of its reservations? This can\'t be undone.'**
  String deleteTableWarning(String tableName);

  /// No description provided for @gameName.
  ///
  /// In en, this message translates to:
  /// **'Game system name'**
  String get gameName;

  /// No description provided for @addGame.
  ///
  /// In en, this message translates to:
  /// **'Add game system'**
  String get addGame;

  /// No description provided for @gameAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This game system already exists'**
  String get gameAlreadyExists;

  /// No description provided for @noGames.
  ///
  /// In en, this message translates to:
  /// **'There are no game systems yet'**
  String get noGames;

  /// No description provided for @deleteGameWarning.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{gameName}\" from the available game systems? Existing reservations keep their game name.'**
  String deleteGameWarning(String gameName);

  /// No description provided for @searchReservations.
  ///
  /// In en, this message translates to:
  /// **'Search by user, table or game'**
  String get searchReservations;

  /// No description provided for @reservationDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get reservationDate;

  /// No description provided for @reservationTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get reservationTime;

  /// No description provided for @reservationTable.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get reservationTable;

  /// No description provided for @reservationUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get reservationUser;

  /// No description provided for @reservationGame.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get reservationGame;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @exportReservations.
  ///
  /// In en, this message translates to:
  /// **'Export reservations'**
  String get exportReservations;

  /// No description provided for @exportSelectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get exportSelectDateRange;

  /// No description provided for @exportAllGames.
  ///
  /// In en, this message translates to:
  /// **'All game systems'**
  String get exportAllGames;

  /// No description provided for @exportDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get exportDownload;

  /// No description provided for @exportDone.
  ///
  /// In en, this message translates to:
  /// **'Reservations exported'**
  String get exportDone;

  /// No description provided for @hidePastReservations.
  ///
  /// In en, this message translates to:
  /// **'Hide past reservations'**
  String get hidePastReservations;

  /// No description provided for @noReservations.
  ///
  /// In en, this message translates to:
  /// **'No reservations found'**
  String get noReservations;

  /// No description provided for @deleteReservationWarning.
  ///
  /// In en, this message translates to:
  /// **'Delete the reservation of {userName}?'**
  String deleteReservationWarning(String userName);

  /// No description provided for @adminEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get adminEvents;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @eventDescription.
  ///
  /// In en, this message translates to:
  /// **'Reserves every table for the chosen period, with no maximum duration. The event name is used as the game name of each reservation.'**
  String get eventDescription;

  /// No description provided for @eventName.
  ///
  /// In en, this message translates to:
  /// **'Event name'**
  String get eventName;

  /// No description provided for @eventStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get eventStart;

  /// No description provided for @eventEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get eventEnd;

  /// No description provided for @createEvent.
  ///
  /// In en, this message translates to:
  /// **'Create event'**
  String get createEvent;

  /// No description provided for @eventEndBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'The end must be after the start'**
  String get eventEndBeforeStart;

  /// No description provided for @eventNoTables.
  ///
  /// In en, this message translates to:
  /// **'There are no tables to reserve'**
  String get eventNoTables;

  /// No description provided for @eventCreated.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Event created: 1 table reserved} other{Event created: {count} tables reserved}}'**
  String eventCreated(int count);

  /// No description provided for @eventConflictsTitle.
  ///
  /// In en, this message translates to:
  /// **'Some tables are already reserved'**
  String get eventConflictsTitle;

  /// No description provided for @eventConflictsBody.
  ///
  /// In en, this message translates to:
  /// **'Delete these reservations first, then create the event again:'**
  String get eventConflictsBody;

  /// No description provided for @noRouteDefined.
  ///
  /// In en, this message translates to:
  /// **'No route defined for {routeName}'**
  String noRouteDefined(String routeName);
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
      <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
