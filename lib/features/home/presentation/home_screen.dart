import 'package:flutter/material.dart';
import 'package:reservations_app/app_routes.dart';
import 'package:reservations_app/features/profile/presentation/profile_screen.dart';
import 'package:reservations_app/features/reservations/presentation/delete_reservations_screen.dart';
import 'package:reservations_app/features/reservations/presentation/make_reservations_screen.dart';
import 'package:reservations_app/widgets/reserve_table_buttons.dart';
import 'package:reservations_app/features/authentication/presentation/auth_controller.dart';

enum Page { makeReservationsPage, deleteReservationsPage, userProfilePage, unknownPage }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<HomeScreen> {
  final _authController = AuthController();
  final selectedDateNotifier = ValueNotifier(DateTime.now());
  var selectedIndex = Page.makeReservationsPage;
  var pageTitle = 'ERROR';
  
  @override
  Widget build(BuildContext context) {
    Widget page;

    // Figure out which page we should show
    switch (selectedIndex) {
      case Page.makeReservationsPage:
        page = const MakeReservationsScreen();
        pageTitle = 'New reservation';
        break;
      case Page.deleteReservationsPage:
        page = const DeleteReservationsScreen();
        pageTitle = 'My reservations';
        break;
      case Page.userProfilePage:
        page = const UserProfileScreen();
        pageTitle = "User profile";
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // Build app bar buttons
    final makeReservationsButton = CustomIconButton(
      icon: Icons.more_time,
      onPressed: () => setState(() {
        selectedIndex = Page.makeReservationsPage;
      }),
    );

    final deleteReservationsButton = CustomIconButton(
      icon: Icons.auto_delete_outlined,
      onPressed: () => setState(() {
        selectedIndex = Page.deleteReservationsPage;
      }),
    );

    final userProfileButton = CustomIconButton(
      icon: Icons.person,
      onPressed: () => setState(() {
        selectedIndex = Page.userProfilePage;
      }),
    );

    final logOutButton = CustomIconButton(
      icon: Icons.logout,
      onPressed: () {
        _authController.signOutUser(context);
        AppRoutes.navigateTo(context, AppRoutes.login);
      }
    );

    // Build Scaffold
    Scaffold scaffold = Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(pageTitle),
        actions: [
          makeReservationsButton,
          deleteReservationsButton,
          userProfileButton,
          logOutButton,
        ],
      ),
      body: page,
    );

    // Find scaffold constraints
    double width = MediaQuery.sizeOf(context).width;
    double widtFactor = 1;
    if (width > 600) {
      widtFactor = 600 / width;
    }

    // Creturn width constrained scaffold
    return FractionallySizedBox(
      widthFactor: widtFactor,
      child: scaffold,
    );
  }
}
