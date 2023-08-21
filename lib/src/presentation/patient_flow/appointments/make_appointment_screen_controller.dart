import 'dart:async';

import 'package:doctor_appointment/src/data/appointment_repo.dart';
import 'package:doctor_appointment/src/data/auth_repo.dart';
import 'package:doctor_appointment/src/data/doctor_repo.dart';
import 'package:doctor_appointment/src/domain/appointment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/user.dart';

class MakeAppointmentScreenController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> makeAppointment(
      {required AppUser doctor, required DateTime start}) async {
    final currentUser = ref.watch(currentUserProvider).asData?.value;

    if (currentUser != null) {
      final appointmentRepo = ref.watch(appointmentRepositoryProvider);
      final doctorRepo = ref.watch(doctorRepositoryProvider);

      state = const AsyncLoading();
      final appointment = Appointment(
        doctorId: doctor.id!,
        doctorName: doctor.name,
        patientId: currentUser.id!,
        patientName: currentUser.name,
        start: start,
        isApproved: false,
      );
      state = await AsyncValue.guard(() async {
        appointmentRepo.makeAppointment(appointment: appointment);
        doctorRepo.deleteTimeSlots(doctor.id!, [start]);
      });
    }
    return state.hasError == false;
  }
}

final makeAppointmentScreenControllerProvider =
    AsyncNotifierProvider.autoDispose<MakeAppointmentScreenController, void>(
        () {
  return MakeAppointmentScreenController();
});
