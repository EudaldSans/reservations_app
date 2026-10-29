import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import 'package:reservations_app/features/admin/data/admin_repository.dart';
import 'package:reservations_app/features/admin/domain/game_model.dart';
import 'package:reservations_app/features/authentication/presentation/auth_controller.dart';
import 'package:reservations_app/l10n/app_localizations.dart';

class AdminEventsTab extends StatefulWidget {
  final AdminRepository repository;

  const AdminEventsTab({super.key, required this.repository});

  @override
  State<AdminEventsTab> createState() => _AdminEventsTabState();
}

class _AdminEventsTabState extends State<AdminEventsTab> {
  final _authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late final Stream<List<GameModel>> _games = widget.repository.watchGames();
  String? _gameName;
  // Bumped to rebuild the dropdown when the selected game is deleted
  int _gameFieldResets = 0;

  late DateTime _start = _today(18);
  late DateTime _end = _today(23);
  bool _endBeforeStart = false;
  bool _isSaving = false;

  static DateTime _today(int hour) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickDateTime(DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date == null || !mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _selectStart() async {
    final picked = await _pickDateTime(_start);
    if (picked == null) return;

    setState(() {
      // Keep the duration, so moving the start doesn't silently invalidate
      // the end.
      _end = picked.add(_end.difference(_start));
      _start = picked;
      _endBeforeStart = false;
    });
  }

  Future<void> _selectEnd() async {
    final picked = await _pickDateTime(_end);
    if (picked == null) return;

    setState(() {
      _end = picked;
      _endBeforeStart = false;
    });
  }

  Future<void> _create() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    if (!_end.isAfter(_start)) {
      setState(() => _endBeforeStart = true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = await _authController.getCurrentUserData();
      if (user == null) throw StateError('Current user not found');

      final count = await widget.repository.createEvent(
        name: _nameController.text.trim(),
        gameName: _gameName!,
        userId: user.id,
        userName: user.name,
        start: _start,
        end: _end,
      );

      if (!mounted) return;
      _nameController.clear();
      toastification.show(
          title: Text(l10n.eventCreated(count)),
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.success);
    } on NoTablesException {
      if (!mounted) return;
      toastification.show(
          title: Text(l10n.eventNoTables),
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.warning);
    } on EventConflictException catch (e) {
      if (!mounted) return;
      await _showConflicts(e);
    } catch (e) {
      log("Admin events error: $e");
      if (!mounted) return;
      toastification.show(
          title: Text(l10n.genericError),
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.error);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _showConflicts(EventConflictException exception) {
    final l10n = AppLocalizations.of(context);
    final dateTimeFormat = DateFormat.MMMd(
            Localizations.localeOf(context).toString())
        .add_Hm();

    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.eventConflictsTitle),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.eventConflictsBody),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final conflict in exception.conflicts)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '${conflict.tableName} · ${conflict.reservation.userName}'
                            ' · ${dateTimeFormat.format(conflict.reservation.startDate.toDate())}'
                            ' - ${dateTimeFormat.format(conflict.reservation.endDate.toDate())}',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _dateTimeButton(String label, DateTime value, VoidCallback onTap) {
    final format = DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .add_Hm();

    return OutlinedButton.icon(
      onPressed: _isSaving ? null : onTap,
      icon: const Icon(Icons.event),
      label: Text('$label: ${format.format(value)}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.eventDescription),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                enabled: !_isSaving,
                decoration: InputDecoration(
                  labelText: l10n.eventName,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.validationRequired
                    : null,
              ),
              const SizedBox(height: 16),
              StreamBuilder<List<GameModel>>(
                stream: _games,
                builder: (context, snapshot) {
                  final names = <String>{
                    ...?snapshot.data?.map((game) => game.name),
                  };
                  if (_gameName != null && !names.contains(_gameName)) {
                    _gameName = null;
                    _gameFieldResets++;
                  }

                  return DropdownButtonFormField<String>(
                    key: ValueKey(_gameFieldResets),
                    initialValue: _gameName,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.selectGameSystem,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      for (final name in names)
                        DropdownMenuItem(value: name, child: Text(name)),
                    ],
                    onChanged: _isSaving
                        ? null
                        : (value) => setState(() => _gameName = value),
                    validator: (value) =>
                        value == null ? l10n.validationRequired : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  _dateTimeButton(l10n.eventStart, _start, _selectStart),
                  _dateTimeButton(l10n.eventEnd, _end, _selectEnd),
                ],
              ),
              if (_endBeforeStart)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.eventEndBeforeStart,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _create,
                icon: _isSaving
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.celebration),
                label: Text(l10n.createEvent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
