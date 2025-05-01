import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:parcking_slot_booking/features/parcking/models/parking_slot_model.dart';

class HistoryPage extends StatelessWidget {
  final List<ParkingSlot> allSlots;

  HistoryPage({required this.allSlots});

  @override
  Widget build(BuildContext context) {
    // Filter only booked slots
    final bookedSlots = allSlots.where((slot) => 
      slot.status == 'Blocked' || 
      (slot.startTime != null && slot.endTime != null)
    ).toList();

    return Scaffold(
      appBar: AppBar(title: Text("My Booking History")),
      body: bookedSlots.isEmpty
          ? Center(child: Text("No bookings yet."))
          : ListView.builder(
              itemCount: bookedSlots.length,
              itemBuilder: (context, index) {
                final slot = bookedSlots[index];
                return Card(
                  margin: EdgeInsets.all(12),
                  child: ListTile(
                    title: Text('${slot.id} - ${slot.row}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (slot.startTime != null && slot.endTime != null)
                          Text('Booked: ${slot.startTime} to ${slot.endTime}'),
                        if (slot.entryTime != null)
                          Text('Entry: ${slot.entryTime}'),
                        if (slot.exitTime != null)
                          Text('Exit: ${slot.exitTime}'),
                        if (slot.entryTime != null && slot.exitTime != null)
                          Text('Payable: \$${calculateFee(slot.entryTime!, slot.exitTime!)}'),
                      ],
                    ),
                    onTap: () => _handleEntryExit(context, slot),
                  ),
                );
              },
            ),
    );
  }

  void _handleEntryExit(BuildContext context, ParkingSlot slot) async {
    final now = DateTime.now();

    if (slot.entryTime == null) {
      slot.entryTime = now;
      Get.snackbar("Entry Recorded", "Entry at ${now.hour}:${now.minute.toString().padLeft(2, '0')}");
    } else if (slot.exitTime == null) {
      slot.exitTime = now;
      Get.snackbar("Exit Recorded", "Exit at ${now.hour}:${now.minute.toString().padLeft(2, '0')}\n"
          "Payable: \$${calculateFee(slot.entryTime!, slot.exitTime!)}");
    }

    // Update in Firestore
    await FirebaseFirestore.instance
        .collection('bookings')
        .where('slotId', isEqualTo: slot.id)
        .where('row', isEqualTo: slot.row)
        .get()
        .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            FirebaseFirestore.instance
                .collection('bookings')
                .doc(snapshot.docs.first.id)
                .update(slot.toMap());
          }
        });
  }

  int calculateFee(DateTime entry, DateTime exit) {
    final duration = exit.difference(entry);
    if (duration.inMinutes <= 10) return 0;
    final hours = (duration.inMinutes / 60).ceil();
    return hours * 100;
  }
}
