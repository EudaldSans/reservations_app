import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import 'package:reservations_app/features/admin/data/admin_repository.dart';
import 'package:reservations_app/features/admin/domain/event_model.dart';
import 'package:reservations_app/features/admin/domain/game_model.dart';
import 'package:reservations_app/features/admin/presentation/confirm_dialog.dart';
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
  late final Stream<List<AdminEvent>> _events =
      widget.repository.watchUpcomingEvents();
  String? _gameName;

  /// The event loaded in the form, null when creating a new one
  AdminEvent? _editing;
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
    // An event being edited may have started earlier than the usual limit
    final earliest = DateTime.now().subtract(const Duration(days: 1));
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: initial.isBefore(earliest) ? initial : earliest,
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

  void _startEditing(AdminEvent event) {
    setState(() {
      _editing = event;
      _nameController.text = event.name;
      // If the game was deleted since, the dropdown clears and asks again
      _gameName = event.gameName;
      _gameFieldResets++;
      _start = event.start;
      _end = event.end;
      _endBeforeStart = false;
    });
  }

  void _stopEditing() {
    setState(() {
      _editing = null;
      _nameController.clear();
      _gameName = null;
      _gameFieldResets++;
      _start = _today(18);
      _end = _today(23);
      _endBeforeStart = false;
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    if (!_end.isAfter(_start)) {
      setState(() => _endBeforeStart = true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final editing = _editing;
      if (editing != null) {
        await widget.repository.updateEvent(
          event: editing,
          name: _nameController.text.trim(),
          gameName: _gameName!,
          start: _start,
          end: _end,
        );

        if (!mounted) return;
        _stopEditing();
        toastification.show(
            title: Text(l10n.eventUpdated),
            autoCloseDuration: const Duration(seconds: 5),
            type: ToastificationType.success);
        return;
      }

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

  Future<void> _cancel(AdminEvent event) async {
    final l10n = AppLocalizations.of(context);

    final confirmed =
        await confirmDestructiveAction(context, l10n.cancelEventWarning(event.name));
    if (!confirmed) return;

    try {
      await widget.repository.deleteReservations(event.reservationIds);

      if (!mounted) return;
      // Nothing left to edit if the event being edited was just cancelled
      if (_editing?.reservations.first.id == event.reservations.first.id) {
        _stopEditing();
      }
      toastification.show(
          title: Text(l10n.eventCancelled),
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.success);
    } catch (e) {
      log("Admin cancel event error: $e");
      if (!mounted) return;
      toastification.show(
          title: Text(l10n.genericError),
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.error);
    }
  }

  Widget _buildEvents(AppLocalizations l10n) {
    final locale = Localizations.localeOf(context).toString();
    final dateTime = DateFormat.MMMd(locale).add_Hm();
    final time = DateFormat.Hm(locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.upcomingEvents,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Expanded(
          child: StreamBuilder<List<AdminEvent>>(
            stream: _events,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(l10n.genericError));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final events = snapshot.data!;
              if (events.isEmpty) {
                return Center(child: Text(l10n.noUpcomingEvents));
              }

              return Card(
                child: ListView.separated(
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final sameDay = event.start.year == event.end.year &&
                        event.start.month == event.end.month &&
                        event.start.day == event.end.day;
                    final period = sameDay
                        ? '${dateTime.format(event.start)} - ${time.format(event.end)}'
                        : '${dateTime.format(event.start)} - ${dateTime.format(event.end)}';

                    return ListTile(
                      leading: const Icon(Icons.celebration),
                      title: Text(event.name),
                      subtitle: Text(
                          '${event.gameName} · $period · ${l10n.adminTables}: ${event.tableCount}'),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: l10n.edit,
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: _isSaving
                                ? null
                                : () => _startEditing(event),
                          ),
                          IconButton(
                            tooltip: l10n.cancelEvent,
                            icon: const Icon(Icons.event_busy),
                            onPressed: () => _cancel(event),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
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

    // Create form on the left, the events that can be cancelled on the right
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 480,
          child: SingleChildScrollView(child: _buildForm(l10n)),
        ),
        const SizedBox(width: 32),
        Expanded(child: _buildEvents(l10n)),
      ],
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_editing != null) ...[
                Text(l10n.editEvent,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
              ],
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
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: _isSaving ? null : _submit,
                    icon: _isSaving
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(_editing == null ? Icons.celebration : Icons.save),
                    label: Text(_editing == null ? l10n.createEvent : l10n.save),
                  ),
                  if (_editing != null) ...[
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: _isSaving ? null : _stopEditing,
                      child: Text(l10n.cancel),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
