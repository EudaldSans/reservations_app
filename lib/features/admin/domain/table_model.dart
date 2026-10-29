import 'package:cloud_firestore/cloud_firestore.dart';

class TableModel {
  final String id;
  final String name;

  /// Dimensions in centimeters
  final int length;
  final int width;

  const TableModel({
    required this.id,
    required this.name,
    required this.length,
    required this.width,
  });

  factory TableModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TableModel(
      id: doc.id,
      name: data['tableName'] ?? '',
      length: (data['length'] as num?)?.toInt() ?? 0,
      width: (data['width'] as num?)?.toInt() ?? 0,
    );
  }
}
