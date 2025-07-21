import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:reservations_app/features/reservations/data/reservation_repository.dart';

Row createReservationText(BuildContext context, Timestamp startTime, Timestamp endTime, String userName, String gameName) {
  // Create DateTime objects from the Timestamps
  final startDateTime = startTime.toDate();
  final endDateTime = endTime.toDate();

  // Format them with a 24-hour format
  String formattedStart = DateFormat('HH:mm').format(startDateTime);
  String formattedEnd = DateFormat('HH:mm').format(endDateTime);

  return Row(
    children: [
      const Icon(
        Icons.access_time,
        size: 16,
      ),
      const SizedBox(width: 4),
      Text(
        '$formattedStart - $formattedEnd',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      const SizedBox(width: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.casino_outlined,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                gameName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          )
        ],
      )
      
    ],
  );
}

class TableCard extends StatefulWidget {
  final int length;
  final int width;
  final String tableName;
  final DateTime selectedDate;
  final String tableID;

  const TableCard({
    super.key,
    required this.length,
    required this.width,
    required this.tableName,
    required this.selectedDate,
    required this.tableID,
  });

  @override
  State<TableCard> createState() => _TableCardState();
}

class _TableCardState extends State<TableCard> {
  final ReservationRepository _reservationRepository = ReservationRepository();

  @override
  Widget build(BuildContext context) {
    final inchesLength = (widget.length / 2.54).toStringAsFixed(0);
    final inchesWidth = (widget.width / 2.54).toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.tableName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                Icons.aspect_ratio,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                "${widget.length} x ${widget.width} cm, $inchesLength x $inchesWidth in",
              ),
            ],
          ),
          const SizedBox(height: 8),
          StreamBuilder(
            stream: _reservationRepository.watchTableReservations(widget.tableID, widget.selectedDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No reserved slots',
                    style: TextStyle(color: Colors.grey[500]));
              }

              final reservationList = snapshot.data;
              if (reservationList == null) {
                return Text('No reserved slots',
                    style: TextStyle(color: Colors.grey[500]));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reservationList.length,
                itemBuilder: (context, index) {
                  final reservation = reservationList[index];
                  return createReservationText(
                      context, reservation.startDate, reservation.endDate, reservation.userName, reservation.gameName);
                });
            },
          ),
        ],
      ),
    );
  }
}
