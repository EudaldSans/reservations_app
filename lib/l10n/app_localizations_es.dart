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
  String noRouteDefined(String routeName) {
    return 'No hay ninguna ruta definida para $routeName';
  }
}
