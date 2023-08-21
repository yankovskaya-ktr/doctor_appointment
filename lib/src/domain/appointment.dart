class Appointment {
  final String? id;
  final String doctorId;
  final String doctorName;
  final String patientId;
  final String patientName;
  final DateTime start;
  final bool isApproved;

  Appointment({
    this.id,
    required this.doctorId,
    required this.doctorName,
    required this.patientId,
    required this.patientName,
    required this.start,
    required this.isApproved,
  });

  factory Appointment.fromMap(Map<dynamic, dynamic> map, String id) {
    return Appointment(
      id: id,
      doctorId: map['doctorId'] as String,
      doctorName: map['doctorName'] as String,
      patientId: map['patientId'] as String,
      patientName: map['patientName'] as String,
      start: map['start'].toDate(),
      isApproved: map['isApproved'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'doctorId': doctorId,
      'doctorName': doctorName,
      'patientId': patientId,
      'patientName': patientName,
      'start': start,
      'isApproved': isApproved,
    };
  }
}
