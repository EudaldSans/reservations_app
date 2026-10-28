import 'package:cloud_firestore/cloud_firestore.dart';

class GameModel {
  final String id;
  final String name;

  const GameModel({required this.id, required this.name});

  factory GameModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GameModel(id: doc.id, name: data['name'] ?? '');
  }
}
