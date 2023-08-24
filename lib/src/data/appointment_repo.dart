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

  Future<String> makeAppointment({required Appointment appointment}) async {
    final doc = await _appointmentsRef.add(appointment);
    return doc.id;
  }

  Future<Appointment> getAppointment(String id) async {
    final snapshot = await _appointmentsRef.doc(id).get();
    return snapshot.data()!;
  }

  Future<void> deleteAppointment(String id) =>
      _appointmentsRef.doc(id).delete();

  Future<void> confirmAppointment(String id) =>
      _appointmentsRef.doc(id).update({'isApproved': true});

  /// Get all forthcoming appointments for a petient ordered by date
  Query<Appointment> queryAppointmentsForPatient(String patientId) =>
      _appointmentsRef
          .where('patientId', isEqualTo: patientId)
          .where('start', isGreaterThanOrEqualTo: DateTime.timestamp())
          .orderBy('start');

  /// Get all forthcoming appointments for a doctor ordered by date
  Query<Appointment> queryAppointmentsForDoctor(String doctorId) =>
      _appointmentsRef
          .where('doctorId', isEqualTo: doctorId)
          .where('start', isGreaterThanOrEqualTo: DateTime.timestamp())
          .orderBy('start');
}

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return AppointmentRepository(firestore);
});

final appointmentsForPatientQueryProvider =
    Provider.autoDispose.family<Query<Appointment>, String>((ref, patientId) {
  final appointmentRepo = ref.watch(appointmentRepositoryProvider);
  return appointmentRepo.queryAppointmentsForPatient(patientId);
});

final appointmentsForDoctorQueryProvider =
    Provider.autoDispose.family<Query<Appointment>, String>((ref, doctorId) {
  final appointmentRepo = ref.watch(appointmentRepositoryProvider);
  return appointmentRepo.queryAppointmentsForDoctor(doctorId);
});

final appointmentProvider =
    FutureProvider.autoDispose.family<Appointment, String>(
  (ref, appointmentId) async {
    final appointmentRepo = ref.watch(appointmentRepositoryProvider);
    return appointmentRepo.getAppointment(appointmentId);
  },
);
