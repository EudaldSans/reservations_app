import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Row createReservationText(BuildContext context, Timestamp startTime, Timestamp endTime, String userName) {
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
  Stream<QuerySnapshot>? _reservationsStream;

  @override
  void initState() {
    super.initState();
    // Create a stream for all reservations for this table
    _reservationsStream = FirebaseFirestore.instance
        .collection("reservations")
        .where('tableID', isEqualTo: widget.tableID)
        .snapshots();
  }

  List<DocumentSnapshot> _filterReservationsForDate(
    List<DocumentSnapshot> allReservations,
    DateTime date,
  ) {
    // Filter for the selected date
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return allReservations.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final Timestamp startDate = data['startDate'];
      final reservationDate =
          DateTime.fromMillisecondsSinceEpoch(startDate.millisecondsSinceEpoch);

      return reservationDate.isAfter(startOfDay) &&
          reservationDate.isBefore(endOfDay);
    }).toList();
  }

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
            stream: _reservationsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('No reserved slots',
                    style: TextStyle(color: Colors.grey[500]));
              }

              final filtered = _filterReservationsForDate(
                snapshot.data!.docs,
                widget.selectedDate,
              );

              if (filtered.isEmpty) {
                return Text('No reserved slots',
                    style: TextStyle(color: Colors.grey[500]));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final data =
                      filtered[index].data() as Map<String, dynamic>;
                  return createReservationText(
                      context, data['startDate'], data['endDate'], data['userName']);
                });
            },
          ),
        ],
      ),
    );
  }
}
