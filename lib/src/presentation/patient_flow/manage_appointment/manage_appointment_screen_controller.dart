import 'dart:async';
import 'package:doctor_appointment/src/domain/appointment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/notification_service.dart';
import '../../../data/appointment_repo.dart';
import '../../../data/doctor_repo.dart';

class ManageAppointmentScreenController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  /// Delete appointment and add timeslot for a doctor
  Future<bool> cancelAppointment(Appointment appointment) async {
    final appointmentRepo = ref.watch(appointmentRepositoryProvider);
    final doctorRepo = ref.watch(doctorRepositoryProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      appointmentRepo.deleteAppointment(appointment.id!);
      doctorRepo.addTimeSlots(appointment.doctorId, [appointment.start]);
      _cancelReminder(appointment.id!);
    });

    return state.hasError == false;
  }

  Future<void> _cancelReminder(String id) =>
      NotificationsService.cancelNotification(id.hashCode);
}

final manageAppointmentsScreenControllerProvider =
    AsyncNotifierProvider.autoDispose<ManageAppointmentScreenController, void>(
        () {
  return ManageAppointmentScreenController();
});
