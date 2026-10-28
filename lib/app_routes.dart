import 'package:flutter/material.dart';
import 'package:reservations_app/features/admin/presentation/admin_screen.dart';
import 'package:reservations_app/features/authentication/presentation/login_screen.dart';
import 'package:reservations_app/features/authentication/presentation/signup_screen.dart';
import 'package:reservations_app/features/home/presentation/home_screen.dart';
import 'package:reservations_app/l10n/app_localizations.dart';

class AppRoutes {
  // Route names as constants
  static const String initial = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String makeReservations = '/make-reservations';
  static const String deleteReservations = '/delete-reservations';
  static const String admin = '/admin';

  // Route definitions
  static Map<String, WidgetBuilder> get routes {
    return {
      login: (_) => const LoginScreen(),
      signup: (_) => const SignupScreen(),
      home: (_) => const HomeScreen(),
      admin: (_) => const AdminScreen(),
    };
  }

  // Handle unknown routes
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context)
              .noRouteDefined(settings.name ?? '')),
        ),
      ),
    );
  }

  // Navigation methods
  static void navigateTo(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void navigateToAndRemove(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false,
        arguments: arguments);
  }

  static void navigateToAndReplace(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
