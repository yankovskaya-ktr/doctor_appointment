// import 'dart:async';
// import 'package:doctor_appointment/src/domain/appointment.dart';
// import 'package:doctor_appointment/src/domain/daily_appointments.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../data/appointment_repo.dart';
// import '../../../data/auth_repo.dart';


// TODO: this may turn into AppointmentScreen controller

// class DailyAppointmentsListController
//     extends AutoDisposeAsyncNotifier<List<DailyAppointments>> {
//   @override
//   Future<List<DailyAppointments>> build() async {
//     return _getDailyAppointmentsForPatient();
//   }

//   Future<List<DailyAppointments>> _getDailyAppointmentsForPatient() async {
//     final appointmentRepo = ref.watch(appointmentRepositoryProvider);
//     final currentUser = ref.watch(currentUserProvider).asData?.value;

//     if (currentUser != null) {
//       return await appointmentRepo
//           .queryAppointmentsForPatient(currentUser.id!)
//           .then((appointments) => DailyAppointments.getAll(appointments));
//     }
//     return [];
//   }

//   // cancel appointment method
//   Future<void> cancelAppointmet(Appointment todo) async {
//     // state =
//   }
// }

// final appointmentsListControllerProvider = AsyncNotifierProvider.autoDispose<
//     DailyAppointmentsListController, List<DailyAppointments>>(() {
//   return DailyAppointmentsListController();
// });
