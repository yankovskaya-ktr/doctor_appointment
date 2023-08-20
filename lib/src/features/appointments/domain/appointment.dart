class Appointment {
  final String? id;
  final String doctorId;
  final String patientId;
  final DateTime start;
  final bool isApproved;

  Appointment({
    this.id,
    required this.doctorId,
    required this.patientId,
    required this.start,
    required this.isApproved,
  });

  factory Appointment.fromMap(Map<dynamic, dynamic> map, String id) {
    final startMilliseconds = map['start'] as int;
    return Appointment(
      id: id,
      doctorId: map['doctorId'] as String,
      patientId: map['patientId'] as String,
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      isApproved: map['isApproved'] as bool,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'jobId': jobId,
  //     'start': start.millisecondsSinceEpoch,
  //     'end': end.millisecondsSinceEpoch,
  //     'comment': comment,
  //   };
  // }
}
