import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import 'package:reservations_app/features/admin/data/admin_repository.dart';
import 'package:reservations_app/features/admin/domain/table_model.dart';
import 'package:reservations_app/features/admin/presentation/confirm_dialog.dart';
import 'package:reservations_app/features/reservations/domain/reservation_model.dart';
import 'package:reservations_app/l10n/app_localizations.dart';

class AdminReservationsTab extends StatefulWidget {
  final AdminRepository repository;

  const AdminReservationsTab({super.key, required this.repository});

  @override
  State<AdminReservationsTab> createState() => _AdminReservationsTabState();
}

class _AdminReservationsTabState extends State<AdminReservationsTab> {
  // Created once so rebuilding while typing in the search field doesn't
  // resubscribe to Firestore.
  late final Stream<List<Reservation>> _reservations =
      widget.repository.watchAllReservations();
  late final Stream<List<TableModel>> _tables = widget.repository.watchTables();
  String _search = '';

  Future<void> _delete(Reservation reservation) async {
    final confirmed = await confirmDestructiveAction(
        context,
        AppLocalizations.of(context)
            .deleteReservationWarning(reservation.userName));
    if (!confirmed) return;

    try {
      await widget.repository.deleteReservation(reservation.id);
    } catch (e) {
      log("Admin reservations error: $e");
      if (!mounted) return;
      toastification.show(
          title: Text(AppLocalizations.of(context).genericError),
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat.yMMMd(locale);
    final timeFormat = DateFormat('HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 400,
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l10n.searchReservations,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) =>
                setState(() => _search = value.trim().toLowerCase()),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: StreamBuilder<List<TableModel>>(
            stream: _tables,
            builder: (context, tablesSnapshot) {
              final tableNames = {
                for (final table in tablesSnapshot.data ?? <TableModel>[])
                  table.id: table.name
              };

              return StreamBuilder<List<Reservation>>(
                stream: _reservations,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(l10n.genericError));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final reservations = snapshot.data!.where((reservation) {
                    if (_search.isEmpty) return true;
                    final tableName = tableNames[reservation.tableId] ?? '';
                    return [reservation.userName, reservation.gameName, tableName]
                        .any((text) => text.toLowerCase().contains(_search));
                  }).toList();

                  if (reservations.isEmpty) {
                    return Center(child: Text(l10n.noReservations));
                  }

                  return Card(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text(l10n.reservationDate)),
                            DataColumn(label: Text(l10n.reservationTime)),
                            DataColumn(label: Text(l10n.reservationTable)),
                            DataColumn(label: Text(l10n.reservationUser)),
                            DataColumn(label: Text(l10n.reservationGame)),
                            const DataColumn(label: SizedBox.shrink()),
                          ],
                          rows: [
                            for (final reservation in reservations)
                              DataRow(
                                key: ValueKey(reservation.id),
                                cells: [
                                  DataCell(Text(dateFormat
                                      .format(reservation.startDate.toDate()))),
                                  DataCell(Text(
                                      '${timeFormat.format(reservation.startDate.toDate())}'
                                      ' - ${timeFormat.format(reservation.endDate.toDate())}')),
                                  DataCell(Text(
                                      tableNames[reservation.tableId] ??
                                          l10n.unknownTable)),
                                  DataCell(Text(reservation.userName)),
                                  DataCell(Text(reservation.gameName)),
                                  DataCell(IconButton(
                                    tooltip: l10n.delete,
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _delete(reservation),
                                  )),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
