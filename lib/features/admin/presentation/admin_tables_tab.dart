import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'package:reservations_app/features/admin/data/admin_repository.dart';
import 'package:reservations_app/features/admin/domain/table_model.dart';
import 'package:reservations_app/features/admin/presentation/confirm_dialog.dart';
import 'package:reservations_app/l10n/app_localizations.dart';

class AdminTablesTab extends StatelessWidget {
  final AdminRepository repository;

  const AdminTablesTab({super.key, required this.repository});

  void _showError(BuildContext context, Object error) {
    log("Admin tables error: $error");
    toastification.show(
        title: Text(AppLocalizations.of(context).genericError),
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.error);
  }

  Future<void> _edit(BuildContext context, TableModel? table) async {
    final result = await showDialog<_TableFormResult>(
      context: context,
      builder: (_) => _TableDialog(table: table),
    );
    if (result == null) return;

    try {
      await repository.saveTable(
        id: table?.id,
        name: result.name,
        length: result.length,
        width: result.width,
      );
    } catch (e) {
      if (context.mounted) _showError(context, e);
    }
  }

  Future<void> _delete(BuildContext context, TableModel table) async {
    final confirmed = await confirmDestructiveAction(
        context, AppLocalizations.of(context).deleteTableWarning(table.name));
    if (!confirmed) return;

    try {
      await repository.deleteTable(table.id);
    } catch (e) {
      if (context.mounted) _showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () => _edit(context, null),
            icon: const Icon(Icons.add),
            label: Text(l10n.addTable),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: StreamBuilder<List<TableModel>>(
            stream: repository.watchTables(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(l10n.genericError));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final tables = snapshot.data!;
              if (tables.isEmpty) {
                return Center(child: Text(l10n.noTables));
              }

              return Card(
                child: ListView.separated(
                  itemCount: tables.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final table = tables[index];
                    return ListTile(
                      leading: const Icon(Icons.table_restaurant),
                      title: Text(table.name),
                      subtitle: Text('${table.length} x ${table.width} cm'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: l10n.edit,
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _edit(context, table),
                          ),
                          IconButton(
                            tooltip: l10n.delete,
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _delete(context, table),
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
}

class _TableFormResult {
  final String name;
  final int length;
  final int width;

  const _TableFormResult(this.name, this.length, this.width);
}

/// Create (table == null) or edit a table
class _TableDialog extends StatefulWidget {
  final TableModel? table;

  const _TableDialog({this.table});

  @override
  State<_TableDialog> createState() => _TableDialogState();
}

class _TableDialogState extends State<_TableDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController =
      TextEditingController(text: widget.table?.name ?? '');
  late final _lengthController =
      TextEditingController(text: widget.table?.length.toString() ?? '');
  late final _widthController =
      TextEditingController(text: widget.table?.width.toString() ?? '');

  @override
  void dispose() {
    _nameController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context).validationRequired;
    }
    return null;
  }

  String? _validateDimension(String? value) {
    final number = int.tryParse(value?.trim() ?? '');
    if (number == null || number <= 0) {
      return AppLocalizations.of(context).validationPositiveNumber;
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(_TableFormResult(
      _nameController.text.trim(),
      int.parse(_lengthController.text.trim()),
      int.parse(_widthController.text.trim()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(widget.table == null ? l10n.addTable : l10n.editTable),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: InputDecoration(labelText: l10n.tableName),
                validator: _validateName,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _lengthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.tableLength),
                      validator: _validateDimension,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _widthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.tableWidth),
                      validator: _validateDimension,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.save)),
      ],
    );
  }
}
