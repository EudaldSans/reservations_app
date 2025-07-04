import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:reservations_app/widgets/date_selector.dart';

import '../domain/reservation_model.dart';

class ReservationRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final Uuid uuidGenerator;

  ReservationRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    Uuid? uuidGenerator,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance,
        uuidGenerator = uuidGenerator ?? const Uuid();

  /// Get current user ID or null if not authenticated
  String? getCurrentUserId() {
    return auth.currentUser?.uid;
  }

  Future<void> deleteAllReservations(String userId) async {
    final snapshot = await firestore
      .collection("reservations")
      .where('userID', isEqualTo: userId)
      .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
      log("Deleted reservation with ID: ${doc.id}");
    }

    log("All reservations for user $userId deleted.");
  }

  Future<List<Reservation>> getUserReservations(String userID) async {
    final snapshot = await firestore
      .collection("reservations")
      .where('userID', isEqualTo: userID)
      .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
        return Reservation(
        id: doc.id,
        userId: data['userID'],
        tableId: data['tableID'],
        startDate: data['startDate'],
        endDate: data['endDate'],
        creationDate: data['creationDate'] ?? Timestamp.now(),
      );
    }).toList();
  }

  /// Get reservations for a specific table on a specific date
  Future<List<Reservation>> getTableReservations(
      String tableId, DateTime date) async {
    final nextDay = date.add(const Duration(days: 1));

    // First filter by tableID only, then filter dates in memory
    final snapshot = await firestore
        .collection("reservations")
        .where('tableID', isEqualTo: tableId)
        .get();

    // Filter the date range in application code instead of using a second where clause
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Reservation(
        id: doc.id,
        userId: data['userID'],
        tableId: data['tableID'],
        startDate: data['startDate'],
        endDate: data['endDate'],
        creationDate: data['creationDate'] ?? Timestamp.now(),
      );
    }).where((reservation) {
      // Filter for reservations on the specified date
      final startMillis = reservation.startDate.millisecondsSinceEpoch;
      final dateMillis = Timestamp.fromDate(date).millisecondsSinceEpoch;
      final nextDayMillis = Timestamp.fromDate(nextDay).millisecondsSinceEpoch;
      return startMillis >= dateMillis && startMillis < nextDayMillis;
    }).toList();
  }

  /// Create a new reservation
  Future<bool> createReservation({
    required String tableId,
    required String userId,
    required Timestamp startDate,
    required Timestamp endDate,
    required String userName,
  }) async {
    final id = uuidGenerator.v4();

    try {
      await firestore.collection("reservations").doc(id).set({
        "userID": userId,
        "creationDate": FieldValue.serverTimestamp(),
        "tableID": tableId,
        "startDate": startDate,
        "endDate": endDate,
        "userName": userName,
      });

      return true;
    } catch (e) {
      log("Error creating reservation: $e");
      return false;
    }
  }

  /// Check if a time slot is available
  Future<bool> isTimeSlotAvailable({
    required String tableId,
    required Timestamp startTime,
    required Timestamp endTime,
    required DateTime date,
  }) async {
    if (startTime.millisecondsSinceEpoch >= endTime.millisecondsSinceEpoch) {
      log("Start and end times should not be equal or start later than end!");
      return false;
    }

    final reservations = await getTableReservations(tableId, date);

    for (var reservation in reservations) {
      if (Reservation.doTimeSlotsOverlap(
          startTime, endTime, reservation.startDate, reservation.endDate)) {
        log("Selected slot overlaps with an existing reservation!");
        return false;
      }
    }

    return true;
  }

  /// Get all reserved time slots for a given table on a specific date
  Stream<List<Reservation>> watchTableReservations(
      String tableId, DateTime date) {
    final nextDay = date.add(const Duration(days: 1));
    final dateTimestamp = Timestamp.fromDate(date);
    final nextDayTimestamp = Timestamp.fromDate(nextDay);

    return firestore
        .collection("reservations")
        .where('tableID', isEqualTo: tableId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Reservation(
                id: doc.id,
                userId: data['userID'],
                tableId: data['tableID'],
                startDate: data['startDate'],
                endDate: data['endDate'],
                creationDate: data['creationDate'] ?? Timestamp.now(),
              );
            }).where((reservation) {
              // Filter for reservations on the specified date
              final startMillis = reservation.startDate.millisecondsSinceEpoch;
              return startMillis >= dateTimestamp.millisecondsSinceEpoch &&
                  startMillis < nextDayTimestamp.millisecondsSinceEpoch;
            }).toList());
  }

  /// Convert TimeOfDay to DateTime
  DateTime timeOfDayToDateTime(DateTime baseDate, TimeOfDay timeOfDay) {
    // Create a new DateTime that preserves the year, month, day from baseDate
    // but uses hours and minutes from timeOfDay
    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  void deleteOutdatedReservations() {
    FirebaseFirestore.instance.collection("reservations").where('userID',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((snapshot) {
      for(var index = 0; index < snapshot.docs.length; index++){
        Timestamp reservationTime = snapshot.docs[index].data()['startDate'];
        if (reservationTime.millisecondsSinceEpoch < getTodayAt0000().millisecondsSinceEpoch) {
          FirebaseFirestore.instance
              .collection("reservations")
              .doc(snapshot.docs[index].id)
              .delete()
              .then((_) {
            log("Reservation deleted");
          });
        }
      }
    });
  }
}
