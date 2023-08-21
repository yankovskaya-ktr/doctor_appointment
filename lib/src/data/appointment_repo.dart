import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/src/domain/appointment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

class AppointmentRepository {
  final FirebaseFirestore _firestore;

  AppointmentRepository(this._firestore);

  CollectionReference<Appointment> get _appointmentsRef =>
      _firestore.collection('appointments').withConverter(
            fromFirestore: (snapshot, _) =>
                Appointment.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (appointment, _) => appointment.toMap(),
          );

  Future<void> makeAppointment({required Appointment appointment}) =>
      _appointmentsRef.add(appointment);

  // get all patient's appointments
  Query<Appointment> queryAppointmentsForPatient(String patientId) =>
      _appointmentsRef.where('patientId', isEqualTo: patientId);

  // cancel appointment

  // approve appointment
}

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return AppointmentRepository(firestore);
});
