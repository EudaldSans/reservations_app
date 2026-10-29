import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reservations_app/features/admin/domain/game_model.dart';
import 'package:reservations_app/features/admin/domain/table_model.dart';
import 'package:reservations_app/features/reservations/domain/reservation_model.dart';

/// There is no table the event could reserve
class NoTablesException implements Exception {}

/// Some tables already have a reservation overlapping the event
class EventConflictException implements Exception {
  final List<({String tableName, Reservation reservation})> conflicts;

  EventConflictException(this.conflicts);
}

class AdminRepository {
  final FirebaseFirestore firestore;

  AdminRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  // Tables

  Stream<List<TableModel>> watchTables() {
    return firestore
        .collection('tables')
        .orderBy('tableName')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(TableModel.fromFirestore).toList());
  }

  /// Creates a table, or updates it when [id] is given
  Future<void> saveTable({
    String? id,
    required String name,
    required int length,
    required int width,
  }) {
    final collection = firestore.collection('tables');
    final data = {'tableName': name, 'length': length, 'width': width};

    if (id == null) {
      return collection.add(data);
    }
    return collection.doc(id).update(data);
  }

  /// Deletes a table together with its reservations, so none is left pointing
  /// to a table that no longer exists.
  Future<void> deleteTable(String id) async {
    final reservations = await firestore
        .collection('reservations')
        .where('tableID', isEqualTo: id)
        .get();

    final batch = firestore.batch();
    for (final doc in reservations.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(firestore.collection('tables').doc(id));
    await batch.commit();
  }

  // Game systems

  Stream<List<GameModel>> watchGames() {
    return firestore.collection('games').snapshots().map((snapshot) {
      final games = snapshot.docs.map(GameModel.fromFirestore).toList();
      games.sort((first, second) =>
          first.name.toLowerCase().compareTo(second.name.toLowerCase()));
      return games;
    });
  }

  Future<void> addGame(String name) {
    return firestore.collection('games').add({'name': name});
  }

  Future<void> deleteGame(String id) {
    return firestore.collection('games').doc(id).delete();
  }

  // Reservations

  /// Every reservation of every user, earliest first
  Stream<List<Reservation>> watchAllReservations() {
    return firestore.collection('reservations').snapshots().map((snapshot) {
      final reservations =
          snapshot.docs.map(Reservation.fromFirestore).toList();
      reservations.sort((first, second) => first.startDate
          .millisecondsSinceEpoch
          .compareTo(second.startDate.millisecondsSinceEpoch));
      return reservations;
    });
  }

  Future<void> deleteReservation(String id) {
    return firestore.collection('reservations').doc(id).delete();
  }

  /// Reservations starting in [from] (inclusive) to [to] (exclusive), earliest
  /// first, optionally only those for the game [gameName].
  Future<List<Reservation>> getReservations({
    required DateTime from,
    required DateTime to,
    String? gameName,
  }) async {
    final snapshot = await firestore.collection('reservations').get();

    final reservations = snapshot.docs.map(Reservation.fromFirestore).where(
        (reservation) {
      final start = reservation.startDate.toDate();
      return !start.isBefore(from) &&
          start.isBefore(to) &&
          (gameName == null || reservation.gameName == gameName);
    }).toList();

    reservations.sort((first, second) => first.startDate.millisecondsSinceEpoch
        .compareTo(second.startDate.millisecondsSinceEpoch));
    return reservations;
  }

  /// Reservations that have already ended
  Future<List<Reservation>> getPastReservations() async {
    final snapshot = await firestore.collection('reservations').get();
    final now = DateTime.now();

    return snapshot.docs
        .map(Reservation.fromFirestore)
        .where((reservation) => reservation.endDate.toDate().isBefore(now))
        .toList();
  }

  Future<void> deleteReservations(List<String> ids) async {
    // A batch holds at most 500 writes
    for (var offset = 0; offset < ids.length; offset += 500) {
      final batch = firestore.batch();
      for (final id in ids.skip(offset).take(500)) {
        batch.delete(firestore.collection('reservations').doc(id));
      }
      await batch.commit();
    }
  }

  /// Table names by table id
  Future<Map<String, String>> getTableNames() async {
    final snapshot = await firestore.collection('tables').get();
    return {
      for (final doc in snapshot.docs) doc.id: TableModel.fromFirestore(doc).name
    };
  }

  // Events

  /// Reserves every table from [start] to [end], using the event [name] as the
  /// game name. Unlike regular reservations there is no maximum duration and
  /// the event may span several days.
  ///
  /// All the reservations are written in one batch, so either every table is
  /// reserved or none is. Returns the number of reserved tables.
  ///
  /// Throws [NoTablesException] when there are no tables and
  /// [EventConflictException] when any table is already reserved during the
  /// event, in which case nothing is written.
  Future<int> createEvent({
    required String name,
    required String userId,
    required String userName,
    required DateTime start,
    required DateTime end,
  }) async {
    final tables = await firestore.collection('tables').get();
    if (tables.docs.isEmpty) throw NoTablesException();

    final tableNames = {
      for (final doc in tables.docs) doc.id: TableModel.fromFirestore(doc).name
    };
    final startDate = Timestamp.fromDate(start);
    final endDate = Timestamp.fromDate(end);

    final existing = await firestore.collection('reservations').get();
    final conflicts = [
      for (final reservation in existing.docs.map(Reservation.fromFirestore))
        if (tableNames.containsKey(reservation.tableId) &&
            Reservation.doTimeSlotsOverlap(
                startDate, endDate, reservation.startDate, reservation.endDate))
          (
            tableName: tableNames[reservation.tableId]!,
            reservation: reservation,
          )
    ];
    if (conflicts.isNotEmpty) throw EventConflictException(conflicts);

    final batch = firestore.batch();
    for (final tableId in tableNames.keys) {
      batch.set(firestore.collection('reservations').doc(), {
        'userID': userId,
        'creationDate': FieldValue.serverTimestamp(),
        'tableID': tableId,
        'startDate': startDate,
        'endDate': endDate,
        'userName': userName,
        'gameName': name,
      });
    }
    await batch.commit();

    return tableNames.length;
  }
}
