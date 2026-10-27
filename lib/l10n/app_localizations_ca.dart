// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'Aplicació de reserves';

  @override
  String get login => 'Inicia la sessió';

  @override
  String get signup => 'Registra\'t';

  @override
  String get name => 'Nom';

  @override
  String get enterName => 'Introdueix el teu nom';

  @override
  String get email => 'Correu electrònic';

  @override
  String get enterEmail => 'Introdueix el teu correu electrònic';

  @override
  String get password => 'Contrasenya';

  @override
  String get enterPassword => 'Introdueix la teva contrasenya';

  @override
  String get forgotPassword => 'Has oblidat la contrasenya?';

  @override
  String get noAccountPrompt => 'No tens un compte?';

  @override
  String get haveAccountPrompt => 'Ja tens un compte?';

  @override
  String get validationEnterName => 'Introdueix el teu nom';

  @override
  String get validationEnterEmail => 'Introdueix el teu correu electrònic';

  @override
  String get validationValidEmail => 'Introdueix un correu electrònic vàlid';

  @override
  String get validationEnterPassword => 'Introdueix la teva contrasenya';

  @override
  String get validationPasswordLength =>
      'La contrasenya ha de tenir almenys 6 caràcters';

  @override
  String get enterEmailToResetPassword =>
      'Introdueix el teu correu electrònic per restablir la contrasenya';

  @override
  String get passwordResetEmailSent =>
      'S\'ha enviat el correu de restabliment de la contrasenya!';

  @override
  String get authInvalidEmail => 'El correu electrònic no és vàlid.';

  @override
  String get authInvalidCredentials =>
      'Correu electrònic o contrasenya incorrectes.';

  @override
  String get authEmailAlreadyInUse =>
      'Ja existeix un compte amb aquest correu electrònic.';

  @override
  String get authWeakPassword => 'La contrasenya és massa dèbil.';

  @override
  String get authTooManyRequests =>
      'Massa intents. Torna-ho a provar més tard.';

  @override
  String get authNetworkError =>
      'Error de xarxa. Comprova la connexió i torna-ho a provar.';

  @override
  String get authRequiresRecentLogin =>
      'Torna a iniciar la sessió abans de fer això.';

  @override
  String get authUserDisabled => 'Aquest compte ha estat deshabilitat.';

  @override
  String get genericError => 'Alguna cosa ha anat malament. Torna-ho a provar.';

  @override
  String get newReservation => 'Nova reserva';

  @override
  String get myReservations => 'Les meves reserves';

  @override
  String get userProfile => 'Perfil d\'usuari';

  @override
  String get profileId => 'ID';

  @override
  String get profileCreated => 'Creat';

  @override
  String get deleteUser => 'Elimina l\'usuari';

  @override
  String get deleteUserWarning =>
      'Aquesta acció eliminarà el teu usuari i totes les teves reserves. Vols continuar?';

  @override
  String get couldNotFindUser => 'No s\'ha pogut trobar l\'usuari actual!';

  @override
  String get dialogCareful => 'Compte!';

  @override
  String get cancel => 'Cancel·la';

  @override
  String get confirm => 'Confirma';

  @override
  String get submit => 'ENVIA';

  @override
  String get reservationCreated => 'Franja horària reservada correctament!';

  @override
  String get reservationCreateFailed => 'No s\'ha pogut crear la reserva';

  @override
  String get reservationLoginRequired => 'Inicia la sessió per fer una reserva';

  @override
  String get reservationEqualTimes =>
      'L\'hora d\'inici i la de fi no poden ser iguals!';

  @override
  String get reservationTooMany => 'No pots tenir més de 5 reserves actives';

  @override
  String get reservationSlotUnavailable =>
      'La franja horària seleccionada no està disponible';

  @override
  String get noTablesAvailable => 'No hi ha taules disponibles';

  @override
  String get noReservedSlots => 'No hi ha franges reservades';

  @override
  String get unknownTable => 'Taula desconeguda';

  @override
  String get loadingGames => 'Carregant jocs...';

  @override
  String get selectGameSystem => 'Selecciona un sistema de joc';

  @override
  String get unableToLoadGames => 'No s\'han pogut carregar els jocs';

  @override
  String get retryLoadingGames => 'Torna a provar de carregar els jocs';

  @override
  String noRouteDefined(String routeName) {
    return 'No hi ha cap ruta definida per a $routeName';
  }
}
