import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reservations_app/app_routes.dart';
import 'package:reservations_app/features/authentication/data/firebase_options.dart';
import 'package:toastification/toastification.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return ToastificationWrapper(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: (user != null) ? AppRoutes.home : AppRoutes.login,
      routes: AppRoutes.routes,
      onUnknownRoute: AppRoutes.onUnknownRoute,
      title: 'Reservations App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blueAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        // If locale not supported, fallback to Spanish
        return const Locale('es');
      },
    ));
  }
}
