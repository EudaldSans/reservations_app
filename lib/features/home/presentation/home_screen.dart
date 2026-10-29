import 'package:flutter/material.dart';
import 'package:reservations_app/app_routes.dart';
import 'package:reservations_app/features/profile/presentation/profile_screen.dart';
import 'package:reservations_app/features/reservations/presentation/delete_reservations_screen.dart';
import 'package:reservations_app/features/reservations/presentation/make_reservations_screen.dart';
import 'package:reservations_app/widgets/reserve_table_buttons.dart';
import 'package:reservations_app/features/authentication/presentation/auth_controller.dart';
import 'package:reservations_app/l10n/app_localizations.dart';

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
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadAdminStatus();
  }

  Future<void> _loadAdminStatus() async {
    try {
      final user = await _authController.getCurrentUserData();
      if (!mounted || user == null) return;
      setState(() => _isAdmin = user.admin);
    } catch (_) {
      // Stay a regular user if the profile can't be loaded
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget page;

    // Figure out which page we should show
    switch (selectedIndex) {
      case Page.makeReservationsPage:
        page = const MakeReservationsScreen();
        pageTitle = l10n.newReservation;
        break;
      case Page.deleteReservationsPage:
        page = const DeleteReservationsScreen();
        pageTitle = l10n.myReservations;
        break;
      case Page.userProfilePage:
        page = const UserProfileScreen();
        pageTitle = l10n.userProfile;
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

    final adminButton = CustomIconButton(
      icon: Icons.admin_panel_settings,
      onPressed: () => AppRoutes.navigateTo(context, AppRoutes.admin),
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
          if (_isAdmin) adminButton,
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
