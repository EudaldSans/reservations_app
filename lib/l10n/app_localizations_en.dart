// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Reservations App';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Signup';

  @override
  String get name => 'Name';

  @override
  String get enterName => 'Enter Name';

  @override
  String get email => 'Email';

  @override
  String get enterEmail => 'Enter Email';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get noAccountPrompt => 'Don\'t have an account?';

  @override
  String get haveAccountPrompt => 'Already have an account?';

  @override
  String get validationEnterName => 'Please enter your name';

  @override
  String get validationEnterEmail => 'Please enter your email';

  @override
  String get validationValidEmail => 'Please enter a valid email';

  @override
  String get validationEnterPassword => 'Please enter your password';

  @override
  String get validationPasswordLength =>
      'Password must be at least 6 characters';

  @override
  String get enterEmailToResetPassword =>
      'Please enter your email to reset password';

  @override
  String get passwordResetEmailSent => 'Password reset email sent!';

  @override
  String get authInvalidEmail => 'The email address is not valid.';

  @override
  String get authInvalidCredentials => 'Incorrect email or password.';

  @override
  String get authEmailAlreadyInUse =>
      'An account already exists for this email.';

  @override
  String get authWeakPassword => 'The password is too weak.';

  @override
  String get authTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get authNetworkError =>
      'Network error. Check your connection and try again.';

  @override
  String get authRequiresRecentLogin =>
      'Please log in again before doing this.';

  @override
  String get authUserDisabled => 'This account has been disabled.';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get newReservation => 'New reservation';

  @override
  String get myReservations => 'My reservations';

  @override
  String get userProfile => 'User profile';

  @override
  String get language => 'Language';

  @override
  String get languageAutomatic => 'Automatic';

  @override
  String get profileId => 'ID';

  @override
  String get profileCreated => 'Created';

  @override
  String get deleteUser => 'Delete User';

  @override
  String get deleteUserWarning =>
      'This action will delete your user and all reservations, do you want to continue?';

  @override
  String get couldNotFindUser => 'Could not find current user!';

  @override
  String get dialogCareful => 'Careful!';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get submit => 'SUBMIT';

  @override
  String get reservationCreated => 'Time slot successfully reserved!';

  @override
  String get reservationCreateFailed => 'Failed to create reservation';

  @override
  String get reservationLoginRequired => 'Please login to make a reservation';

  @override
  String get reservationEqualTimes =>
      'Start and end times should not be equal!';

  @override
  String get reservationTooMany =>
      'You can\'t have more than 5 active reservations';

  @override
  String get reservationSlotUnavailable =>
      'Selected time slot is not available';

  @override
  String get noTablesAvailable => 'No tables available';

  @override
  String get noReservedSlots => 'No reserved slots';

  @override
  String get unknownTable => 'Unknown Table';

  @override
  String get loadingGames => 'Loading games...';

  @override
  String get selectGameSystem => 'Select a game system';

  @override
  String get unableToLoadGames => 'Unable to load games';

  @override
  String get retryLoadingGames => 'Retry loading games';

  @override
  String get adminPanel => 'Admin panel';

  @override
  String get adminTables => 'Tables';

  @override
  String get adminGames => 'Game systems';

  @override
  String get adminReservations => 'Reservations';

  @override
  String get adminAccessDenied => 'You don\'t have access to this page';

  @override
  String get backToApp => 'Back to the app';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationPositiveNumber => 'Enter a whole number greater than 0';

  @override
  String get addTable => 'Add table';

  @override
  String get editTable => 'Edit table';

  @override
  String get tableName => 'Table name';

  @override
  String get tableLength => 'Length (cm)';

  @override
  String get tableWidth => 'Width (cm)';

  @override
  String get noTables => 'There are no tables yet';

  @override
  String deleteTableWarning(String tableName) {
    return 'Delete \"$tableName\" and all of its reservations? This can\'t be undone.';
  }

  @override
  String get gameName => 'Game system name';

  @override
  String get addGame => 'Add game system';

  @override
  String get gameAlreadyExists => 'This game system already exists';

  @override
  String get noGames => 'There are no game systems yet';

  @override
  String deleteGameWarning(String gameName) {
    return 'Remove \"$gameName\" from the available game systems? Existing reservations keep their game name.';
  }

  @override
  String get searchReservations => 'Search by user, table or game';

  @override
  String get reservationDate => 'Date';

  @override
  String get reservationTime => 'Time';

  @override
  String get reservationTable => 'Table';

  @override
  String get reservationUser => 'User';

  @override
  String get reservationGame => 'Game';

  @override
  String get hidePastReservations => 'Hide past reservations';

  @override
  String get noReservations => 'No reservations found';

  @override
  String deleteReservationWarning(String userName) {
    return 'Delete the reservation of $userName?';
  }

  @override
  String get adminEvents => 'Events';

  @override
  String get close => 'Close';

  @override
  String get eventDescription =>
      'Reserves every table for the chosen period, with no maximum duration. The event name is used as the game name of each reservation.';

  @override
  String get eventName => 'Event name';

  @override
  String get eventStart => 'Start';

  @override
  String get eventEnd => 'End';

  @override
  String get createEvent => 'Create event';

  @override
  String get eventEndBeforeStart => 'The end must be after the start';

  @override
  String get eventNoTables => 'There are no tables to reserve';

  @override
  String eventCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Event created: $count tables reserved',
      one: 'Event created: 1 table reserved',
    );
    return '$_temp0';
  }

  @override
  String get eventConflictsTitle => 'Some tables are already reserved';

  @override
  String get eventConflictsBody =>
      'Delete these reservations first, then create the event again:';

  @override
  String noRouteDefined(String routeName) {
    return 'No route defined for $routeName';
  }
}
