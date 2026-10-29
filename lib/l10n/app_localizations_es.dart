// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'App de reservas';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get signup => 'Registrarse';

  @override
  String get name => 'Nombre';

  @override
  String get enterName => 'Introduce tu nombre';

  @override
  String get email => 'Correo electrónico';

  @override
  String get enterEmail => 'Introduce tu correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get enterPassword => 'Introduce tu contraseña';

  @override
  String get forgotPassword => '¿Has olvidado la contraseña?';

  @override
  String get noAccountPrompt => '¿No tienes una cuenta?';

  @override
  String get haveAccountPrompt => '¿Ya tienes una cuenta?';

  @override
  String get validationEnterName => 'Por favor, introduce tu nombre';

  @override
  String get validationEnterEmail =>
      'Por favor, introduce tu correo electrónico';

  @override
  String get validationValidEmail =>
      'Por favor, introduce un correo electrónico válido';

  @override
  String get validationEnterPassword => 'Por favor, introduce tu contraseña';

  @override
  String get validationPasswordLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get enterEmailToResetPassword =>
      'Por favor, introduce tu correo electrónico para restablecer la contraseña';

  @override
  String get passwordResetEmailSent =>
      '¡Correo de restablecimiento de contraseña enviado!';

  @override
  String get authInvalidEmail => 'El correo electrónico no es válido.';

  @override
  String get authInvalidCredentials =>
      'Correo electrónico o contraseña incorrectos.';

  @override
  String get authEmailAlreadyInUse =>
      'Ya existe una cuenta con este correo electrónico.';

  @override
  String get authWeakPassword => 'La contraseña es demasiado débil.';

  @override
  String get authTooManyRequests =>
      'Demasiados intentos. Inténtalo de nuevo más tarde.';

  @override
  String get authNetworkError =>
      'Error de red. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get authRequiresRecentLogin =>
      'Vuelve a iniciar sesión antes de hacer esto.';

  @override
  String get authUserDisabled => 'Esta cuenta ha sido deshabilitada.';

  @override
  String get genericError => 'Algo ha salido mal. Inténtalo de nuevo.';

  @override
  String get newReservation => 'Nueva reserva';

  @override
  String get myReservations => 'Mis reservas';

  @override
  String get userProfile => 'Perfil de usuario';

  @override
  String get language => 'Idioma';

  @override
  String get languageAutomatic => 'Automático';

  @override
  String get profileId => 'ID';

  @override
  String get profileCreated => 'Creado';

  @override
  String get deleteUser => 'Eliminar usuario';

  @override
  String get deleteUserWarning =>
      'Esta acción eliminará tu usuario y todas tus reservas. ¿Quieres continuar?';

  @override
  String get couldNotFindUser =>
      '¡No se ha podido encontrar el usuario actual!';

  @override
  String get dialogCareful => '¡Cuidado!';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get submit => 'ENVIAR';

  @override
  String get reservationCreated => '¡Franja horaria reservada con éxito!';

  @override
  String get reservationCreateFailed => 'No se ha podido crear la reserva';

  @override
  String get reservationLoginRequired => 'Inicia sesión para hacer una reserva';

  @override
  String get reservationEqualTimes =>
      '¡La hora de inicio y la de fin no pueden ser iguales!';

  @override
  String get reservationTooMany => 'No puedes tener más de 5 reservas activas';

  @override
  String get reservationSlotUnavailable =>
      'La franja horaria seleccionada no está disponible';

  @override
  String get noTablesAvailable => 'No hay mesas disponibles';

  @override
  String get noReservedSlots => 'No hay franjas reservadas';

  @override
  String get unknownTable => 'Mesa desconocida';

  @override
  String get loadingGames => 'Cargando juegos...';

  @override
  String get selectGameSystem => 'Selecciona un sistema de juego';

  @override
  String get unableToLoadGames => 'No se han podido cargar los juegos';

  @override
  String get retryLoadingGames => 'Reintentar la carga de juegos';

  @override
  String get adminPanel => 'Panel de administración';

  @override
  String get adminTables => 'Mesas';

  @override
  String get adminGames => 'Sistemas de juego';

  @override
  String get adminReservations => 'Reservas';

  @override
  String get adminAccessDenied => 'No tienes acceso a esta página';

  @override
  String get backToApp => 'Volver a la aplicación';

  @override
  String get add => 'Añadir';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get save => 'Guardar';

  @override
  String get validationRequired => 'Este campo es obligatorio';

  @override
  String get validationPositiveNumber =>
      'Introduce un número entero mayor que 0';

  @override
  String get addTable => 'Añadir mesa';

  @override
  String get editTable => 'Editar mesa';

  @override
  String get tableName => 'Nombre de la mesa';

  @override
  String get tableLength => 'Largo (cm)';

  @override
  String get tableWidth => 'Ancho (cm)';

  @override
  String get noTables => 'Todavía no hay mesas';

  @override
  String deleteTableWarning(String tableName) {
    return '¿Eliminar \"$tableName\" y todas sus reservas? Esta acción no se puede deshacer.';
  }

  @override
  String get gameName => 'Nombre del sistema de juego';

  @override
  String get addGame => 'Añadir sistema de juego';

  @override
  String get gameAlreadyExists => 'Este sistema de juego ya existe';

  @override
  String get noGames => 'Todavía no hay sistemas de juego';

  @override
  String deleteGameWarning(String gameName) {
    return '¿Quitar \"$gameName\" de los sistemas de juego disponibles? Las reservas existentes conservan el nombre del juego.';
  }

  @override
  String get searchReservations => 'Buscar por usuario, mesa o juego';

  @override
  String get reservationDate => 'Fecha';

  @override
  String get reservationTime => 'Hora';

  @override
  String get reservationTable => 'Mesa';

  @override
  String get reservationUser => 'Usuario';

  @override
  String get reservationGame => 'Juego';

  @override
  String get deletePastReservations => 'Eliminar reservas pasadas';

  @override
  String get noPastReservations => 'No hay reservas pasadas que eliminar';

  @override
  String deletePastReservationsWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '¿Eliminar $count reservas pasadas? Esta acción no se puede deshacer.',
      one: '¿Eliminar 1 reserva pasada? Esta acción no se puede deshacer.',
    );
    return '$_temp0';
  }

  @override
  String pastReservationsDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reservas eliminadas',
      one: '1 reserva eliminada',
    );
    return '$_temp0';
  }

  @override
  String get exportCsv => 'Exportar CSV';

  @override
  String get exportReservations => 'Exportar reservas';

  @override
  String get exportSelectDateRange => 'Seleccionar rango de fechas';

  @override
  String get exportAllGames => 'Todos los sistemas de juego';

  @override
  String get exportDownload => 'Descargar';

  @override
  String get exportDone => 'Reservas exportadas';

  @override
  String get hidePastReservations => 'Ocultar reservas pasadas';

  @override
  String get noReservations => 'No se han encontrado reservas';

  @override
  String deleteReservationWarning(String userName) {
    return '¿Eliminar la reserva de $userName?';
  }

  @override
  String get adminEvents => 'Eventos';

  @override
  String get close => 'Cerrar';

  @override
  String get eventDescription =>
      'Reserva todas las mesas durante el periodo elegido, sin duración máxima. Cada reserva muestra el nombre del evento en lugar de tu nombre, junto con el sistema de juego.';

  @override
  String get eventName => 'Nombre del evento';

  @override
  String get eventStart => 'Inicio';

  @override
  String get eventEnd => 'Fin';

  @override
  String get createEvent => 'Crear evento';

  @override
  String get eventEndBeforeStart => 'El fin debe ser posterior al inicio';

  @override
  String get eventNoTables => 'No hay mesas que reservar';

  @override
  String eventCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Evento creado: $count mesas reservadas',
      one: 'Evento creado: 1 mesa reservada',
    );
    return '$_temp0';
  }

  @override
  String get eventConflictsTitle => 'Algunas mesas ya están reservadas';

  @override
  String get eventConflictsBody =>
      'Elimina primero estas reservas y vuelve a crear el evento:';

  @override
  String noRouteDefined(String routeName) {
    return 'No hay ninguna ruta definida para $routeName';
  }
}
