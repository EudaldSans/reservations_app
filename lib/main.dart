import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reservations_app/app_routes.dart';
import 'package:reservations_app/features/authentication/data/firebase_options.dart';
import 'package:toastification/toastification.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    ));
  }
}
