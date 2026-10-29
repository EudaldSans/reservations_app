import 'package:flutter/material.dart';

import 'package:reservations_app/features/admin/data/admin_repository.dart';
import 'package:reservations_app/features/admin/presentation/admin_events_tab.dart';
import 'package:reservations_app/features/admin/presentation/admin_games_tab.dart';
import 'package:reservations_app/features/admin/presentation/admin_reservations_tab.dart';
import 'package:reservations_app/features/admin/presentation/admin_tables_tab.dart';
import 'package:reservations_app/features/authentication/presentation/auth_controller.dart';
import 'package:reservations_app/l10n/app_localizations.dart';

/// Desktop oriented admin pane. Only admin users get past the guard.
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _authController = AuthController();
  final _repository = AdminRepository();
  late final Future<bool> _isAdmin = _checkAdmin();
  int _selectedIndex = 0;

  Future<bool> _checkAdmin() async {
    try {
      final user = await _authController.getCurrentUserData();
      return user?.admin ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<bool>(
      future: _isAdmin,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.data != true) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.adminPanel)),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.adminAccessDenied),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: Text(l10n.backToApp),
                  ),
                ],
              ),
            ),
          );
        }

        final tabs = <Widget>[
          AdminTablesTab(repository: _repository),
          AdminGamesTab(repository: _repository),
          AdminReservationsTab(repository: _repository),
          AdminEventsTab(repository: _repository),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.adminPanel),
            actions: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back),
                label: Text(l10n.backToApp),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) =>
                    setState(() => _selectedIndex = index),
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                    icon: const Icon(Icons.table_restaurant_outlined),
                    selectedIcon: const Icon(Icons.table_restaurant),
                    label: Text(l10n.adminTables),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.casino_outlined),
                    selectedIcon: const Icon(Icons.casino),
                    label: Text(l10n.adminGames),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.event_note_outlined),
                    selectedIcon: const Icon(Icons.event_note),
                    label: Text(l10n.adminReservations),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.celebration_outlined),
                    selectedIcon: const Icon(Icons.celebration),
                    label: Text(l10n.adminEvents),
                  ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: tabs[_selectedIndex],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
