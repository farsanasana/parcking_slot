import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parcking_slot_booking/features/parcking/pages/historypage.dart';
import '../controllers/parking_controller.dart';
import '../models/parking_slot_model.dart';

class ParkingPage extends GetView<ParkingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Parking Slots"),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        final allSlots = controller.parkingSlots;

        List<ParkingSlot> slots = List.generate(12, (index) {
          String id = 'Slot ${index + 1}';
          String row = 'Row ${String.fromCharCode(65 + (index ~/ 3))}';

          return allSlots.firstWhere(
            (slot) => slot.id == id && slot.row == row,
            orElse: () => ParkingSlot(id: id, row: row),
          );
        });

        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: 4,
          itemBuilder: (context, rowIndex) {
            final start = rowIndex * 3;
            final rowSlots = slots.sublist(start, start + 3);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Row ${String.fromCharCode(65 + rowIndex)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: rowSlots.map((slot) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SlotWidget(slot: slot),
                    ),
                  )).toList(),
                ),
                SizedBox(height: 16),
              ],
            );
          },
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: 'Slots',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            // Navigate to HistoryPage
              final controller = Get.find<ParkingController>();
            Get.to(()=>HistoryPage(allSlots: controller.parkingSlots.toList()));
          } else if (index == 2) {
            // Navigate to ProfilePage
          }
        },
      ),
    );
  }
}

class SlotWidget extends StatelessWidget {
  final ParkingSlot slot;

  const SlotWidget({Key? key, required this.slot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isBlocked = slot.status == "Blocked";

    return GestureDetector(
      onTap: () {
        if (!isBlocked) {
          _showBookingDialog(context);
        } else {
          Get.snackbar("Slot Unavailable", "This slot is already booked.");
        }
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isBlocked ? Colors.red : Colors.green,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_parking,
              size: 40,
              color: isBlocked ? Colors.red : Colors.green,
            ),
            SizedBox(height: 8),
            Text(
              slot.id,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              slot.status,
              style: TextStyle(
                color: isBlocked ? Colors.red : Colors.green,
              ),
            ),
            SizedBox(height: 6),
            if (slot.startTime != null && slot.endTime != null)
              Text(
                "${slot.startTime!.hour}:${slot.startTime!.minute.toString().padLeft(2, '0')} - "
                "${slot.endTime!.hour}:${slot.endTime!.minute.toString().padLeft(2, '0')}",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      TextEditingController durationController = TextEditingController();

      Get.defaultDialog(
        title: "Select Duration",
        content: Column(
          children: [
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Duration in hours",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                int hours = int.tryParse(durationController.text) ?? 1;
                final now = DateTime.now();
                final start = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                final end = start.add(Duration(hours: hours));

                final controller = Get.find<ParkingController>();
                controller.bookSlot(slot, start, end);

                Get.back();
              },
              child: Text("Confirm Booking"),
            ),
          ],
        ),
      );
    }
  }
}
