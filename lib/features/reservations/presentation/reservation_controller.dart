import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:reservations_app/features/authentication/presentation/auth_controller.dart';

import 'dart:developer';

import '../data/reservation_repository.dart';
import '../domain/reservation_model.dart';

import 'package:firebase_auth/firebase_auth.dart';

enum ReservationError {
  userNotAuthenticated,
  equalStartAndEndTimes,
  tooManyActiveReservations,
  timeSlotNotAvailable,
  unknown
}

class ReservationResult {
  final bool success;
  final ReservationError? error;

  ReservationResult({
    required this.success,
    this.error,
  });

  static ReservationResult successful() {
    return ReservationResult(success: true);
  }

  static ReservationResult failure(ReservationError error) {
    return ReservationResult(
      success: false,
      error: error,
    );
  }
}

class ReservationController {
  final ReservationRepository repository;
  final AuthController _authController = AuthController();

  ReservationController({ReservationRepository? repository})
      : repository = repository ?? ReservationRepository();

  /// Create a new reservation
  Future<ReservationResult> createReservation({
    required String tableId,
    required DateTime selectedDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String userName,
    required String gameName
  }) async {
    // Check if user is authenticated
    final userId = repository.getCurrentUserId();
    if (userId == null) {
      log("User not authenticated");
      return ReservationResult.failure(ReservationError.userNotAuthenticated);
    }

    // Validate times
    if (startTime.hour == endTime.hour && startTime.minute == endTime.minute) {
      log("Start and end times should not be equal!");
      return ReservationResult.failure(ReservationError.equalStartAndEndTimes);
    }

    // Create DateTime objects from TimeOfDay
    DateTime startDate =
        repository.timeOfDayToDateTime(selectedDate, startTime);
    DateTime endDate = repository.timeOfDayToDateTime(selectedDate, endTime);

    // Debug: Print DateTime objects
    log("DateTime objects created - Start: ${startDate.toString()}, End: ${endDate.toString()}");

    // If end time is earlier than start time, assume it's the next day
    if (endTime.hour < startTime.hour ||
        (endTime.hour == startTime.hour && endTime.minute < startTime.minute)) {
      endDate = endDate.add(const Duration(days: 1));
      log("End time adjusted to next day: ${endDate.toString()}");
    }

    // Convert to Timestamp
    final startTimestamp = Timestamp.fromDate(startDate);
    final endTimestamp = Timestamp.fromDate(endDate);

    // Debug: Print Timestamp objects
    log("Timestamps created - Start: ${startTimestamp.toDate().toString()}, End: ${endTimestamp.toDate().toString()}");

    final activeUserReservations = await repository.getUserReservations(FirebaseAuth.instance.currentUser!.uid);
    final currentUser = await _authController.getCurrentUserData();

    log("Number of reservations: ${activeUserReservations.length}, admin ${currentUser!.admin}");

    if (!currentUser.admin && activeUserReservations.length > 5) {
      return ReservationResult.failure(ReservationError.tooManyActiveReservations);
    }

    // Check availability
    final isAvailable = await repository.isTimeSlotAvailable(
      tableId: tableId,
      startTime: startTimestamp,
      endTime: endTimestamp,
      date: selectedDate,
    );

    if (!isAvailable) {
      return ReservationResult.failure(ReservationError.timeSlotNotAvailable);
    }

    // Create reservation
    final success = await repository.createReservation(
      tableId: tableId,
      userId: userId,
      startDate: startTimestamp,
      endDate: endTimestamp,
      userName: userName,
      gameName: gameName,
    );

    if (success) {
      return ReservationResult.successful();
    } else {
      return ReservationResult.failure(ReservationError.unknown);
    }
  }

  /// Get reservations for a table on a specific date (one-time fetch)
  Future<List<Reservation>> getTableReservations(
      String tableId, DateTime date) async {
    return repository.getTableReservations(tableId, date);
  }

  /// Get all reservations for a table on a specific date as stream
  Stream<List<Reservation>> watchTableReservations(
      String tableId, DateTime date) {
    return repository.watchTableReservations(tableId, date);
  }
}
