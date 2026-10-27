import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reservations_app/app_routes.dart';
import 'package:reservations_app/features/authentication/data/firebase_options.dart';
import 'package:reservations_app/features/authentication/presentation/auth_controller.dart';
import 'package:reservations_app/l10n/app_localizations.dart';
import 'package:reservations_app/l10n/locale_controller.dart';
import 'package:toastification/toastification.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Apply the saved language of an already logged in user before the first
  // frame, so the app doesn't flash in the device language first.
  if (FirebaseAuth.instance.currentUser != null) {
    try {
      final user = await AuthController()
          .getCurrentUserData()
          .timeout(const Duration(seconds: 3));
      LocaleController.setLanguage(user?.language);
    } catch (_) {
      // Offline or slow: keep the device language
    }
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return ToastificationWrapper(
        child: ValueListenableBuilder<Locale?>(
      valueListenable: LocaleController.locale,
      builder: (context, locale, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: (user != null) ? AppRoutes.home : AppRoutes.login,
        routes: AppRoutes.routes,
        onUnknownRoute: AppRoutes.onUnknownRoute,
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // null follows the device / browser language
        locale: locale,
        localeListResolutionCallback: LocaleController.resolve,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blueAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    ));
  }
}
