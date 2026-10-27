import 'package:flutter/material.dart';

import 'package:reservations_app/features/reservations/domain/reservation_model.dart';

List<String> gameNames = <String>[
  'Warhammer 40k', 
  'Warhammer AoS', 
  'Warhammer KT', 
  'Warhammer Warcry', 
  'Punkapocalyptic', 
  'Bolt Action',
  'Taula',
  'Rol',
  'ASOIAF',
  'Magic TG',
  'Bloodbowl',
  'Trench crusade',
  'Altres',
  Reservation.unavailableGameName
];

class GameSelector extends StatefulWidget {
  final Function(String)? onGameChanged;

  const GameSelector({super.key, this.onGameChanged,});

  @override
  State<GameSelector> createState() => _GameSelectorState();
}

class _GameSelectorState extends State<GameSelector> {
  String dropdownValue = 'NULL';

  @override
  void initState() {
    super.initState();
    gameNames.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    
    dropdownValue = Reservation.unavailableGameName;
  }

  @override
  Widget build(BuildContext context) {
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
            decoration: const InputDecoration(
              labelText: 'Select a game system',
              border: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: Colors.white,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });

              if (widget.onGameChanged != null) {
                widget.onGameChanged!(
                    dropdownValue);
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