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
  String get language => 'Idioma';

  @override
  String get languageAutomatic => 'Automàtic';

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
  String get adminPanel => 'Panell d\'administració';

  @override
  String get adminTables => 'Taules';

  @override
  String get adminGames => 'Sistemes de joc';

  @override
  String get adminReservations => 'Reserves';

  @override
  String get adminAccessDenied => 'No tens accés a aquesta pàgina';

  @override
  String get backToApp => 'Torna a l\'aplicació';

  @override
  String get add => 'Afegeix';

  @override
  String get edit => 'Edita';

  @override
  String get delete => 'Elimina';

  @override
  String get save => 'Desa';

  @override
  String get validationRequired => 'Aquest camp és obligatori';

  @override
  String get validationPositiveNumber =>
      'Introdueix un nombre enter més gran que 0';

  @override
  String get addTable => 'Afegeix una taula';

  @override
  String get editTable => 'Edita la taula';

  @override
  String get tableName => 'Nom de la taula';

  @override
  String get tableLength => 'Llargada (cm)';

  @override
  String get tableWidth => 'Amplada (cm)';

  @override
  String get noTables => 'Encara no hi ha taules';

  @override
  String deleteTableWarning(String tableName) {
    return 'Vols eliminar \"$tableName\" i totes les seves reserves? Aquesta acció no es pot desfer.';
  }

  @override
  String get gameName => 'Nom del sistema de joc';

  @override
  String get addGame => 'Afegeix un sistema de joc';

  @override
  String get gameAlreadyExists => 'Aquest sistema de joc ja existeix';

  @override
  String get noGames => 'Encara no hi ha sistemes de joc';

  @override
  String deleteGameWarning(String gameName) {
    return 'Vols treure \"$gameName\" dels sistemes de joc disponibles? Les reserves existents conserven el nom del joc.';
  }

  @override
  String get searchReservations => 'Cerca per usuari, taula o joc';

  @override
  String get reservationDate => 'Data';

  @override
  String get reservationTime => 'Hora';

  @override
  String get reservationTable => 'Taula';

  @override
  String get reservationUser => 'Usuari';

  @override
  String get reservationGame => 'Joc';

  @override
  String get deletePastReservations => 'Elimina les reserves passades';

  @override
  String get noPastReservations => 'No hi ha reserves passades per eliminar';

  @override
  String deletePastReservationsWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Vols eliminar $count reserves passades? Aquesta acció no es pot desfer.',
      one: 'Vols eliminar 1 reserva passada? Aquesta acció no es pot desfer.',
    );
    return '$_temp0';
  }

  @override
  String pastReservationsDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reserves eliminades',
      one: '1 reserva eliminada',
    );
    return '$_temp0';
  }

  @override
  String get exportCsv => 'Exporta CSV';

  @override
  String get exportReservations => 'Exporta les reserves';

  @override
  String get exportSelectDateRange => 'Selecciona un interval de dates';

  @override
  String get exportAllGames => 'Tots els sistemes de joc';

  @override
  String get exportDownload => 'Descarrega';

  @override
  String get exportDone => 'Reserves exportades';

  @override
  String get hidePastReservations => 'Amaga les reserves passades';

  @override
  String get noReservations => 'No s\'ha trobat cap reserva';

  @override
  String deleteReservationWarning(String userName) {
    return 'Vols eliminar la reserva de $userName?';
  }

  @override
  String get adminEvents => 'Esdeveniments';

  @override
  String get close => 'Tanca';

  @override
  String get eventDescription =>
      'Reserva totes les taules durant el període triat, sense durada màxima. El nom de l\'esdeveniment s\'utilitza com a nom del joc de cada reserva.';

  @override
  String get eventName => 'Nom de l\'esdeveniment';

  @override
  String get eventStart => 'Inici';

  @override
  String get eventEnd => 'Fi';

  @override
  String get createEvent => 'Crea l\'esdeveniment';

  @override
  String get eventEndBeforeStart => 'El final ha de ser posterior a l\'inici';

  @override
  String get eventNoTables => 'No hi ha taules per reservar';

  @override
  String eventCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Esdeveniment creat: $count taules reservades',
      one: 'Esdeveniment creat: 1 taula reservada',
    );
    return '$_temp0';
  }

  @override
  String get eventConflictsTitle => 'Algunes taules ja estan reservades';

  @override
  String get eventConflictsBody =>
      'Elimina primer aquestes reserves i torna a crear l\'esdeveniment:';

  @override
  String noRouteDefined(String routeName) {
    return 'No hi ha cap ruta definida per a $routeName';
  }
}
