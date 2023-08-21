import 'dart:async';

import 'package:doctor_appointment/src/data/appointment_repo.dart';
import 'package:doctor_appointment/src/data/auth_repo.dart';
import 'package:doctor_appointment/src/data/doctor_repo.dart';
import 'package:doctor_appointment/src/domain/appointment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MakeAppointmentScreenController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> makeAppointment(
      {required String doctorId, required DateTime start}) async {
    final currentUser = ref.watch(currentUserProvider).asData?.value;

    if (currentUser != null) {
      final appointmentRepo = ref.watch(appointmentRepositoryProvider);
      final doctorRepo = ref.watch(doctorRepositoryProvider);

      state = const AsyncLoading();
      final appointment = Appointment(
          doctorId: doctorId,
          patientId: currentUser.id!,
          start: start,
          isApproved: false);
      state = await AsyncValue.guard(() async {
        appointmentRepo.makeAppointment(appointment: appointment);
        doctorRepo.deleteTimeSlots(doctorId, [start]);
      });
    }
    return state.hasError == false;
  }
}

final makeAppointmentScreenControllerProvider =
    AsyncNotifierProvider<MakeAppointmentScreenController, void>(() {
  return MakeAppointmentScreenController();
});
