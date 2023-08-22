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

  Future<Appointment> getAppointment(String id) async {
    final snapshot = await _appointmentsRef.doc(id).get();
    return snapshot.data()!;
  }

  /// Get all patient's forthcoming appointments ordered by date
  Query<Appointment> queryAppointmentsForPatient(String patientId) =>
      _appointmentsRef
          .where('patientId', isEqualTo: patientId)
          .where('start', isGreaterThanOrEqualTo: DateTime.timestamp())
          .orderBy('start');

  Future<void> deleteAppointment(String id) =>
      _appointmentsRef.doc(id).delete();
  // Future<List<Appointment>> queryAppointmentsForPatient(
  //     String patientId) async {
  //   final snapshots =
  //       await _appointmentsRef.where('patientId', isEqualTo: patientId).get();
  //   return snapshots.docs.map((doc) => doc.data()).toList();
  // }

  // cancel appointment

  // approve appointment
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

final appointmentProvider =
    FutureProvider.autoDispose.family<Appointment, String>(
  (ref, appointmentId) async {
    final appointmentRepo = ref.watch(appointmentRepositoryProvider);
    return appointmentRepo.getAppointment(appointmentId);
  },
);

// final dailyAppointmentsForPatientProvider = Provider.autoDispose
//     .family<List<DailyAppointments>, String>((ref, doctorId) {
//   final appointmentRepo = ref.watch(appointmentRepositoryProvider);
//   final currentUser = ref.watch(currentUserProvider).asData?.value;
//   if (currentUser != null) {
//     final appointments =
//         appointmentRepo.queryAppointmentsForPatient(currentUser.id!);
//   }
//   final doctor = ref.watch(doctorProvider(doctorId));
//   if (doctor.asData != null) {
//     return DailyAppointments.getAll(doctor.asData!.value.timeSlots!);
//   }
//   return [];
// });
