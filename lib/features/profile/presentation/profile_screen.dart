import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

// Firebase
import 'package:reservations_app/app_routes.dart';
import 'package:reservations_app/features/authentication/domain/user_model.dart';
import 'package:reservations_app/features/authentication/presentation/auth_controller.dart';

// Widgets
import 'package:toastification/toastification.dart';
import 'package:reservations_app/widgets/alert_dialog.dart';
import 'package:reservations_app/l10n/app_localizations.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final selectedDateNotifier = ValueNotifier(DateTime.now());
  final AuthController _authController = AuthController();
  UserModel _user = UserModel(id: "id", name: "name", email: "email", createdAt: DateTime.now(), lastLogin: DateTime.now(), admin: false);

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authController.getCurrentUserData();
    if (!mounted) return;

    if (user == null) {
      log("Could not find current user!");
      toastification.show(
          title: Text(AppLocalizations.of(context).couldNotFindUser),
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.error);
      return;
    }

    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                _user.name.isNotEmpty ? _user.name[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 32, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _user.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              _user.email,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(l10n.profileId, _user.id),
            _buildInfoRow(l10n.profileCreated, dateFormat.format(_user.createdAt)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Add your delete logic here
                showAlertDialog(context, 
                  l10n.deleteUserWarning,
                  () {
                    _authController.deleteCurrentUser(context);
                    AppRoutes.navigateTo(context, AppRoutes.login);
                  }
                );
              },
              icon: const Icon(Icons.delete, color: Colors.white),
              label: Text(l10n.deleteUser),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}