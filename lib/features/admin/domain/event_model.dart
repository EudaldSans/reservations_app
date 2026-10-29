import 'package:reservations_app/features/reservations/domain/reservation_model.dart';

/// An event as the admin sees it: the reservations it made on every table,
/// grouped together.
class AdminEvent {
  final String name;
  final String gameName;
  final DateTime start;
  final DateTime end;

  /// The reservation of each table
  final List<Reservation> reservations;

  AdminEvent({
    required this.name,
    required this.gameName,
    required this.start,
    required this.end,
    required this.reservations,
  });

  int get tableCount => reservations.length;

  /// Deleting these reservations cancels the event
  List<String> get reservationIds =>
      reservations.map((reservation) => reservation.id).toList();
}
