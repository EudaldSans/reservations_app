import 'package:intl/intl.dart';

import 'package:reservations_app/features/reservations/domain/reservation_model.dart';

/// Builds the CSV text for [reservations]. [headers] are the six column
/// titles, in the order: start, end, table, user, game, event. The event
/// column is empty for reservations that don't belong to an event.
String buildReservationsCsv({
  required List<Reservation> reservations,
  required Map<String, String> tableNames,
  required List<String> headers,
  required String unknownTable,
}) {
  final dateTime = DateFormat('yyyy-MM-dd HH:mm');

  final rows = [
    headers,
    for (final reservation in reservations)
      [
        dateTime.format(reservation.startDate.toDate()),
        dateTime.format(reservation.endDate.toDate()),
        tableNames[reservation.tableId] ?? unknownTable,
        reservation.userName,
        reservation.gameName,
        reservation.eventName ?? '',
      ],
  ];

  return rows.map((row) => row.map(_cell).join(',')).join('\r\n');
}

String _cell(String value) {
  // User chosen text (names, events) is opened in spreadsheet apps, which run
  // cells starting with these characters as formulas.
  if (value.isNotEmpty && '=+-@\t\r'.contains(value[0])) {
    value = "'$value";
  }

  if (value.contains(RegExp(r'[",\r\n]'))) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}
