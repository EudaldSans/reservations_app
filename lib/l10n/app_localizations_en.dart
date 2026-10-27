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
  String noRouteDefined(String routeName) {
    return 'No route defined for $routeName';
  }
}
