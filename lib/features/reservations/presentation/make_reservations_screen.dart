import 'package:flutter/material.dart';

// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservations_app/features/authentication/domain/user_model.dart';
import 'package:reservations_app/features/authentication/presentation/auth_controller.dart';

// Widgets
import 'package:reservations_app/widgets/date_selector.dart';
import 'package:reservations_app/widgets/table_card.dart';
import 'package:reservations_app/widgets/reserve_table_buttons.dart';

class MakeReservationsScreen extends StatefulWidget {
  const MakeReservationsScreen({super.key});

  @override
  State<MakeReservationsScreen> createState() => _MakeReservationsScreenState();
}

class _MakeReservationsScreenState extends State<MakeReservationsScreen> {
  final selectedDateNotifier = ValueNotifier(DateTime.now());
  // Store the snapshot data
  List<QueryDocumentSnapshot>? tablesSnapshot;
  String _userName = "";
  AuthController _authController = AuthController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load tables data once on init
    FirebaseFirestore.instance.collection("tables").get().then((snapshot) {
      setState(() {
        tablesSnapshot = snapshot.docs;
        isLoading = false;
      });
    });

    _getCurrentUserName();
  }

  Future<void> _getCurrentUserName() async {
    var currentUser = await _authController.getCurrentUserData();

    if (currentUser == null) {
      _userName = "User not found";
      return;
    }

    setState(() {
      _userName = currentUser.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          DateSelector(
            dateNotifier: selectedDateNotifier,
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (tablesSnapshot == null || tablesSnapshot!.isEmpty)
            const Text('No tables available')
          else
            ValueListenableBuilder<DateTime>(
                valueListenable: selectedDateNotifier,
                builder: (context, selectedDate, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: tablesSnapshot!.length,
                    itemBuilder: (context, index) {
                      final table = tablesSnapshot![index];
                      final tableData = table.data() as Map<String, dynamic>;
                      final normalizedDate = DateTime(selectedDate.year,
                          selectedDate.month, selectedDate.day);

                      return Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TableCard(
                              tableName: tableData['tableName'],
                              length: tableData['length'],
                              width: tableData['width'],
                              selectedDate: normalizedDate,
                              tableID: table.id,
                            ),
                          ),
                          ReserveButton(
                              tableID: table.id, selectedDate: normalizedDate, currentUser: _userName),
                        ],
                      );
                    },
                  );
                }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    selectedDateNotifier.dispose();
    super.dispose();
  }
}
