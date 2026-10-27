import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservations_app/l10n/app_localizations.dart';
import 'package:toastification/toastification.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  /// Firebase error messages are always in English, so map the error codes we
  /// know about to localized messages and only fall back to Firebase's text.
  String _errorMessage(AppLocalizations l10n, FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return l10n.authInvalidEmail;
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return l10n.authInvalidCredentials;
      case 'email-already-in-use':
        return l10n.authEmailAlreadyInUse;
      case 'weak-password':
        return l10n.authWeakPassword;
      case 'too-many-requests':
        return l10n.authTooManyRequests;
      case 'network-request-failed':
        return l10n.authNetworkError;
      case 'requires-recent-login':
        return l10n.authRequiresRecentLogin;
      case 'user-disabled':
        return l10n.authUserDisabled;
      default:
        return e.message ?? l10n.genericError;
    }
  }

  void _showError(AppLocalizations l10n, FirebaseAuthException e) {
    log(e.message ?? e.code);
    toastification.show(
        title: Text(_errorMessage(l10n, e)),
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.error);
  }

  Future<User?> createUserWithEmailAndPassword(
      AppLocalizations l10n, String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      _showError(l10n, e);
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      AppLocalizations l10n, String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      _showError(l10n, e);
    }
    return null;
  }

  Future<void> signout(AppLocalizations l10n) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      _showError(l10n, e);
    }
  }

  Future<void> deleteCurrentUser(AppLocalizations l10n) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      _showError(l10n, e);
    }
  }

  Future<void> sendPasswordResetEmail(
      AppLocalizations l10n, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      toastification.show(
        title: Text(l10n.passwordResetEmailSent),
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.success,
      );
    } on FirebaseAuthException catch (e) {
      _showError(l10n, e);
    }
  }
}
