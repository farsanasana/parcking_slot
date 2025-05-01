import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_slot_model.dart';

class ParkingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ParkingSlot>> fetchParkingSlots() async {
    final snapshot = await _firestore.collection('bookings').get();

    return snapshot.docs.map((doc) {
      return ParkingSlot.fromMap(doc.data());
    }).toList();
  }

  Future<void> bookSlot(ParkingSlot slot) async {
    final query = await _firestore
        .collection('bookings')
        .where('slotId', isEqualTo: slot.id)
        .where('row', isEqualTo: slot.row)
        .get();

    final data = slot.toMap();

    if (query.docs.isNotEmpty) {
      final docId = query.docs.first.id;
      await _firestore.collection('bookings').doc(docId).update(data);
    } else {
      await _firestore.collection('bookings').add(data);
    }
  }
}
