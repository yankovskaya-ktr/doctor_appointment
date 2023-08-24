import 'dart:async';
import 'package:doctor_appointment/src/domain/appointment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/notification_service.dart';
import '../../../data/appointment_repo.dart';
import '../../../utils/format.dart';

class AppointmentsListController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<bool> confirmAppointment(Appointment appointment) async {
    final appointmentRepo = ref.watch(appointmentRepositoryProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      appointmentRepo.confirmAppointment(appointment.id!);
      // schedule notification for this appointment, if it is more than 1 day ahead of now
      if (appointment.start.difference(DateTime.now()).inDays > 1) {
        _scheduleReminder(
            appointment.id!, appointment.patientName, appointment.start);
      }
    });

    return state.hasError == false;
  }

  Future<void> _scheduleReminder(
          String id, String patientName, DateTime start) =>
      NotificationsService.scheduleNotification(
        id: id.hashCode,
        scheduledTime: start.subtract(const Duration(days: 1)),
        title: 'Appointment reminder',
        body:
            '${Format.date(start)} at ${Format.time(start)} you have an appointment with $patientName',
      );
}

final appointmentsListControllerProvider =
    AsyncNotifierProvider.autoDispose<AppointmentsListController, void>(() {
  return AppointmentsListController();
});
