import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:reservations_app/features/admin/data/admin_repository.dart';
import 'package:reservations_app/features/admin/domain/game_model.dart';
import 'package:reservations_app/features/reservations/domain/reservation_model.dart';
import 'package:reservations_app/l10n/app_localizations.dart';

class ReservationExportOptions {
  final DateTimeRange dateRange;

  /// Null means every game system
  final String? gameName;

  const ReservationExportOptions(this.dateRange, this.gameName);
}

/// Asks for the date range (required) and the game system (optional) of an
/// export. Pops a [ReservationExportOptions], or null when cancelled.
class ExportReservationsDialog extends StatefulWidget {
  final AdminRepository repository;

  const ExportReservationsDialog({super.key, required this.repository});

  @override
  State<ExportReservationsDialog> createState() =>
      _ExportReservationsDialogState();
}

class _ExportReservationsDialogState extends State<ExportReservationsDialog> {
  late final Future<List<GameModel>> _games =
      widget.repository.watchGames().first;
  DateTimeRange? _dateRange;
  String? _gameName;

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (range != null) setState(() => _dateRange = range);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFormat =
        DateFormat.yMMMd(Localizations.localeOf(context).toString());
    final range = _dateRange;

    return AlertDialog(
      title: Text(l10n.exportReservations),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              onPressed: _pickDateRange,
              icon: const Icon(Icons.date_range),
              label: Text(range == null
                  ? l10n.exportSelectDateRange
                  : '${dateFormat.format(range.start)} - ${dateFormat.format(range.end)}'),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<GameModel>>(
              future: _games,
              builder: (context, snapshot) {
                // "N/A" is the game of reservations made without choosing one
                final names = <String>{
                  Reservation.unavailableGameName,
                  ...?snapshot.data?.map((game) => game.name),
                };

                return DropdownButtonFormField<String?>(
                  initialValue: _gameName,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.adminGames,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                        value: null, child: Text(l10n.exportAllGames)),
                    for (final name in names)
                      DropdownMenuItem<String?>(value: name, child: Text(name)),
                  ],
                  onChanged: (value) => setState(() => _gameName = value),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: range == null
              ? null
              : () => Navigator.of(context)
                  .pop(ReservationExportOptions(range, _gameName)),
          child: Text(l10n.exportDownload),
        ),
      ],
    );
  }
}
