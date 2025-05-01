import 'package:get/get.dart';
import '../models/parking_slot_model.dart';
import '../services/parking_service.dart';

class ParkingController extends GetxController {
  final ParkingService _service = ParkingService();
  var parkingSlots = <ParkingSlot>[].obs;

  @override
  void onInit() {
    fetchSlots();
    super.onInit();
  }

  Future<void> fetchSlots() async {
    final firebaseSlots = await _service.fetchParkingSlots();

    List<ParkingSlot> completeSlots = List.generate(12, (index) {
      String id = 'Slot ${index + 1}';
      String row = 'Row ${String.fromCharCode(65 + (index ~/ 3))}';

      return firebaseSlots.firstWhere(
        (slot) => slot.id == id && slot.row == row,
        orElse: () => ParkingSlot(id: id, row: row),
      );
    });

    parkingSlots.value = completeSlots;
  }

  void bookSlot(ParkingSlot slot, DateTime start, DateTime end) async {
    int index = parkingSlots.indexWhere((s) => s.id == slot.id && s.row == slot.row);

    if (index != -1) {
      parkingSlots[index].status = "Blocked";
      parkingSlots[index].startTime = start;
      parkingSlots[index].endTime = end;
      parkingSlots.refresh();

      try {
        await _service.bookSlot(parkingSlots[index]);
        Get.snackbar("Booking Confirmed", "Slot booked from ${start.hour}:${start.minute.toString().padLeft(2, '0')}");
      } catch (e) {
        parkingSlots[index].status = "Available";
        parkingSlots[index].startTime = null;
        parkingSlots[index].endTime = null;
        parkingSlots.refresh();
        Get.snackbar("Booking Failed", "Something went wrong. Try again.");
      }
    }
  }
}
