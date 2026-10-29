/// An event as the admin sees it: the reservations it made on every table,
/// grouped together.
class AdminEvent {
  final String name;
  final String gameName;
  final DateTime start;
  final DateTime end;

  /// The reservation of each table. Deleting them cancels the event.
  final List<String> reservationIds;

  AdminEvent({
    required this.name,
    required this.gameName,
    required this.start,
    required this.end,
    required this.reservationIds,
  });

  int get tableCount => reservationIds.length;
}
