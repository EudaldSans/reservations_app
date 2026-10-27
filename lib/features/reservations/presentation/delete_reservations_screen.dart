import 'package:flutter/material.dart';
import 'dart:developer';

// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Widgets
import 'package:reservations_app/widgets/reserve_table_buttons.dart';

import 'package:toastification/toastification.dart';

// app
import 'package:reservations_app/widgets/reservation_card.dart';
import 'package:reservations_app/features/reservations/data/reservation_repository.dart';
import 'package:reservations_app/features/reservations/domain/reservation_model.dart';

class DeleteReservationsScreen extends StatefulWidget {
  const DeleteReservationsScreen({super.key});

  @override
  State<DeleteReservationsScreen> createState() =>
      _DeleteReservationsScreenState();
}

class _DeleteReservationsScreenState extends State<DeleteReservationsScreen> {
  final selectedDateNotifier = ValueNotifier(DateTime.now());
  final _reservationRepository = ReservationRepository();

  @override
  void initState() {
    super.initState();

    _reservationRepository.deleteOutdatedReservations();
  }

  @override
  Widget build(BuildContext context) {
    log(FirebaseAuth.instance.currentUser!.uid);

    return FutureBuilder<List<Reservation>>(
      future: _reservationRepository.getUserReservations(FirebaseAuth.instance.currentUser!.uid), 
      builder: (context, AsyncSnapshot<List<Reservation>> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          List<Reservation> reservations = snapshot.data!;

          return Center(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    String tableName = 'Test';

                    Timestamp startTime =
                        reservations[index].startDate;
                    Timestamp endtTime =
                        reservations[index].endDate;
                    DateTime selectedDate = DateTime.fromMillisecondsSinceEpoch(
                        startTime.millisecondsSinceEpoch);

                    return Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ReservationCard(
                            tableID: reservations[index].tableId,
                            selectedDate: selectedDate,
                            reservationStart: startTime,
                            reservationEnd: endtTime,
                            tableName: tableName,
                            gameName: reservations[index].gameName
                          ),
                        ),
                        CustomIconButton(
                          icon:
                              const IconData(0xeeaa, fontFamily: 'MaterialIcons'),
                          onPressed: () {
                            try {
                              FirebaseFirestore.instance
                                  .collection("reservations")
                                  .doc(reservations[index].id)
                                  .delete()
                                  .then((_) {
                                log("Reservation deleted");
                              });
                            } on FirebaseException catch (e) {
                              log(e.message!);
                              toastification.show(
                                  title: Text(e.message!),
                                  autoCloseDuration: const Duration(seconds: 5),
                                  type: ToastificationType.error);
                            }
                          },
                        ),
                      ],
                    );
                  },
                )
              ]
            )
          );
        }
      }
    );
  }
}
