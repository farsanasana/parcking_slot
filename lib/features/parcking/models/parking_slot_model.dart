class ParkingSlot {
  final String id;
  final String row;
  String status; // Available or Blocked
  DateTime? startTime;
  DateTime? endTime;
  DateTime? entryTime;
  DateTime? exitTime;

  ParkingSlot({
    required this.id,
    required this.row,
    this.status = 'Available',
    this.startTime,
    this.endTime,
    this.entryTime,
    this.exitTime,
  });

  factory ParkingSlot.fromMap(Map<String, dynamic> data) {
    return ParkingSlot(
      id: data['slotId'],
      row: data['row'],
      status: data['status'] ?? 'Available',
      startTime: data['startTime'] != null ? DateTime.parse(data['startTime']) : null,
      endTime: data['endTime'] != null ? DateTime.parse(data['endTime']) : null,
      entryTime: data['entryTime'] != null ? DateTime.parse(data['entryTime']) : null,
      exitTime: data['exitTime'] != null ? DateTime.parse(data['exitTime']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'slotId': id,
      'row': row,
      'status': status,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'entryTime': entryTime?.toIso8601String(),
      'exitTime': exitTime?.toIso8601String(),
      'bookedAt': DateTime.now().toIso8601String(),
    };
  }
}
