import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import 'package:reservations_app/features/admin/data/admin_repository.dart';
import 'package:reservations_app/features/admin/domain/reservations_csv.dart';
import 'package:reservations_app/features/admin/domain/table_model.dart';
import 'package:reservations_app/features/admin/presentation/confirm_dialog.dart';
import 'package:reservations_app/features/admin/presentation/export_reservations_dialog.dart';
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
  bool _hidePast = true;

  Future<void> _delete(Reservation reservation) async {
    final confirmed = await confirmDestructiveAction(
        context,
        AppLocalizations.of(context)
            .deleteReservationWarning(reservation.displayName));
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

  Future<void> _deletePast() async {
    final l10n = AppLocalizations.of(context);

    try {
      final past = await widget.repository.getPastReservations();
      if (!mounted) return;

      if (past.isEmpty) {
        toastification.show(
            title: Text(l10n.noPastReservations),
            autoCloseDuration: const Duration(seconds: 5),
            type: ToastificationType.info);
        return;
      }

      final confirmed = await confirmDestructiveAction(
          context, l10n.deletePastReservationsWarning(past.length));
      if (!confirmed) return;

      // Delete exactly what the admin confirmed
      await widget.repository
          .deleteReservations(past.map((reservation) => reservation.id).toList());

      if (!mounted) return;
      toastification.show(
          title: Text(l10n.pastReservationsDeleted(past.length)),
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.success);
    } catch (e) {
      log("Admin delete past reservations error: $e");
      if (!mounted) return;
      toastification.show(
          title: Text(l10n.genericError),
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.error);
    }
  }

  Future<void> _export() async {
    final options = await showDialog<ReservationExportOptions>(
      context: context,
      builder: (_) => ExportReservationsDialog(repository: widget.repository),
    );
    if (options == null || !mounted) return;
    final l10n = AppLocalizations.of(context);

    try {
      final range = options.dateRange;
      final reservations = await widget.repository.getReservations(
        from: DateTime(range.start.year, range.start.month, range.start.day),
        // Exclusive end, so the whole last day is included
        to: DateTime(range.end.year, range.end.month, range.end.day + 1),
        gameName: options.gameName,
      );

      if (reservations.isEmpty) {
        if (!mounted) return;
        toastification.show(
            title: Text(l10n.noReservations),
            autoCloseDuration: const Duration(seconds: 5),
            type: ToastificationType.info);
        return;
      }

      final tableNames = await widget.repository.getTableNames();
      final csv = buildReservationsCsv(
        reservations: reservations,
        tableNames: tableNames,
        headers: [
          l10n.eventStart,
          l10n.eventEnd,
          l10n.reservationTable,
          l10n.reservationUser,
          l10n.reservationGame,
          l10n.eventName,
        ],
        unknownTable: l10n.unknownTable,
      );

      final day = DateFormat('yyyy-MM-dd');
      final saved = await FileSaver.instance.saveAs(
        name: 'reservations_${day.format(range.start)}_${day.format(range.end)}',
        // The BOM lets spreadsheet apps read the accents as UTF-8
        bytes: Uint8List.fromList(utf8.encode('﻿$csv')),
        fileExtension: 'csv',
        mimeType: MimeType.csv,
      );

      // Null when the save dialog was cancelled
      if (saved == null || !mounted) return;
      toastification.show(
          title: Text(l10n.exportDone),
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.success);
    } catch (e) {
      log("Admin export error: $e");
      if (!mounted) return;
      toastification.show(
          title: Text(l10n.genericError),
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
        Wrap(
          spacing: 24,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
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
            InkWell(
              onTap: () => setState(() => _hidePast = !_hidePast),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _hidePast,
                    onChanged: (value) =>
                        setState(() => _hidePast = value ?? true),
                  ),
                  Text(l10n.hidePastReservations),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: _export,
              icon: const Icon(Icons.download),
              label: Text(l10n.exportCsv),
            ),
            OutlinedButton.icon(
              onPressed: _deletePast,
              icon: const Icon(Icons.delete_sweep_outlined),
              label: Text(l10n.deletePastReservations),
            ),
          ],
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

                  final now = DateTime.now();
                  final reservations = snapshot.data!.where((reservation) {
                    // Past means already over: a running one stays listed
                    if (_hidePast && reservation.endDate.toDate().isBefore(now)) {
                      return false;
                    }
                    if (_search.isEmpty) return true;
                    final tableName = tableNames[reservation.tableId] ?? '';
                    return [
                      reservation.userName,
                      reservation.eventName ?? '',
                      reservation.gameName,
                      tableName
                    ].any((text) => text.toLowerCase().contains(_search));
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
                                  DataCell(Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Events show their name instead of the
                                      // admin who created them
                                      if (reservation.eventName != null) ...[
                                        const Icon(Icons.celebration, size: 16),
                                        const SizedBox(width: 6),
                                      ],
                                      Text(reservation.displayName),
                                    ],
                                  )),
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
