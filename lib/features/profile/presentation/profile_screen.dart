import 'package:flutter/material.dart';
import 'dart:developer';

// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservations_app/features/authentication/domain/user_model.dart';
import 'package:reservations_app/features/authentication/presentation/auth_controller.dart';

// Widgets
import 'package:reservations_app/widgets/reserve_table_buttons.dart';

import 'package:toastification/toastification.dart';

// app
import 'package:reservations_app/widgets/reservation_card.dart';
import 'package:reservations_app/widgets/date_selector.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final selectedDateNotifier = ValueNotifier(DateTime.now());
  final AuthController _authController = AuthController();
  UserModel _user = UserModel(id: "id", name: "name", email: "email", createdAt: DateTime.now(), lastLogin: DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authController.getCurrentUserData();

    if (user == null) {
      log("Could not find current user!");
      toastification.show(
          title: Text("Could not find current user!"),
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
    return Text("Placeholder");
  }
}