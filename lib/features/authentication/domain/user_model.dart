import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool admin;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.lastLogin,
    required this.admin,
  });

  // Create from Firebase authentication data plus name
  factory UserModel.fromAuth({
    required String uid,
    required String name,
    required String email,
    required bool admin,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: uid,
      name: name,
      email: email,
      createdAt: now,
      lastLogin: now,
      admin: admin,
    );
  }

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': Timestamp.fromDate(lastLogin),
      'admin': false,
    };
  }

  // Create a copy with updated lastLogin
  UserModel copyWithUpdatedLogin() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      createdAt: createdAt,
      admin: admin,
      lastLogin: DateTime.now(),
    );
  }

  // Create from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      admin: data['admin'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLogin: data['lastLogin'] != null
          ? (data['lastLogin'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
