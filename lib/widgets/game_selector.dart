import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:reservations_app/features/reservations/domain/reservation_model.dart';
import 'package:reservations_app/l10n/app_localizations.dart';

class GameSelector extends StatefulWidget {
  final Function(String)? onGameChanged;

  const GameSelector({
    super.key,
    this.onGameChanged,
  });

  @override
  State<GameSelector> createState() => _GameSelectorState();
}

class _GameSelectorState extends State<GameSelector> {
  String dropdownValue = Reservation.unavailableGameName;
  List<String> gameNames = [Reservation.unavailableGameName];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('games').get();
      final names = <String>{Reservation.unavailableGameName};
      for (final document in snapshot.docs) {
        final name = document.data()['name'];
        if (name is String && name.trim().isNotEmpty) {
          names.add(name);
        }
      }
      final sortedNames = names.toList()
        ..sort((first, second) =>
            first.toLowerCase().compareTo(second.toLowerCase()));

      if (!mounted) return;
      setState(() {
        gameNames = sortedNames;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            value: dropdownValue,
            decoration: InputDecoration(
              labelText:
                  _isLoading ? l10n.loadingGames : l10n.selectGameSystem,
              border: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorText: _hasError ? l10n.unableToLoadGames : null,
              suffixIcon: _hasError
                  ? IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: l10n.retryLoadingGames,
                      onPressed: _loadGames,
                    )
                  : null,
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: Colors.white,
            onChanged: _isLoading || _hasError
                ? null
                : (String? newValue) {
                    if (newValue == null) return;
                    setState(() {
                      dropdownValue = newValue;
                    });

                    if (widget.onGameChanged != null) {
                      widget.onGameChanged!(dropdownValue);
                    }
                  },
            items: gameNames.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
