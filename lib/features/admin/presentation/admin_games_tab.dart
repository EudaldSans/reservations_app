import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'package:reservations_app/features/admin/data/admin_repository.dart';
import 'package:reservations_app/features/admin/domain/game_model.dart';
import 'package:reservations_app/features/admin/presentation/confirm_dialog.dart';
import 'package:reservations_app/features/reservations/domain/reservation_model.dart';
import 'package:reservations_app/l10n/app_localizations.dart';

class AdminGamesTab extends StatefulWidget {
  final AdminRepository repository;

  const AdminGamesTab({super.key, required this.repository});

  @override
  State<AdminGamesTab> createState() => _AdminGamesTabState();
}

class _AdminGamesTabState extends State<AdminGamesTab> {
  final _nameController = TextEditingController();
  List<GameModel> _games = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showError(Object error) {
    log("Admin games error: $error");
    toastification.show(
        title: Text(AppLocalizations.of(context).genericError),
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.error);
  }

  Future<void> _add() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    // "N/A" is always offered by the game selector, so it can't be a game
    final exists = name.toLowerCase() ==
            Reservation.unavailableGameName.toLowerCase() ||
        _games.any((game) => game.name.toLowerCase() == name.toLowerCase());
    if (exists) {
      toastification.show(
          title: Text(l10n.gameAlreadyExists),
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.warning);
      return;
    }

    try {
      await widget.repository.addGame(name);
      _nameController.clear();
    } catch (e) {
      if (mounted) _showError(e);
    }
  }

  Future<void> _delete(GameModel game) async {
    final confirmed = await confirmDestructiveAction(
        context, AppLocalizations.of(context).deleteGameWarning(game.name));
    if (!confirmed) return;

    try {
      await widget.repository.deleteGame(game.id);
    } catch (e) {
      if (mounted) _showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.gameName,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _add(),
              ),
            ),
            const SizedBox(width: 16),
            FilledButton.icon(
              onPressed: _add,
              icon: const Icon(Icons.add),
              label: Text(l10n.addGame),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: StreamBuilder<List<GameModel>>(
            stream: widget.repository.watchGames(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(l10n.genericError));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final games = _games = snapshot.data!;
              if (games.isEmpty) {
                return Center(child: Text(l10n.noGames));
              }

              return Card(
                child: ListView.separated(
                  itemCount: games.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return ListTile(
                      leading: const Icon(Icons.casino_outlined),
                      title: Text(game.name),
                      trailing: IconButton(
                        tooltip: l10n.delete,
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _delete(game),
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
