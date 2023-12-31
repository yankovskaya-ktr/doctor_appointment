import 'dart:async';

import 'package:doctor_appointment/src/data/appointment_repo.dart';
import 'package:doctor_appointment/src/data/auth_repo.dart';
import 'package:doctor_appointment/src/data/doctor_repo.dart';
import 'package:doctor_appointment/src/domain/appointment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/notification_service.dart';
import '../../../domain/user.dart';
import '../../../utils/format.dart';

class MakeAppointmentScreenController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<String?> makeAppointment(
      {required AppUser doctor, required DateTime start}) async {
    String? newAppointmentId;

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
        newAppointmentId =
            await appointmentRepo.makeAppointment(appointment: appointment);
        // schedule notification for this appointment, if it is more than 1 day ahead of now
        if (appointment.start.difference(DateTime.now()).inDays > 1) {
          _scheduleReminder(newAppointmentId!, doctor.name, start);
        }
        doctorRepo.deleteTimeSlots(doctor.id!, [start]);
      });
    }
    return newAppointmentId;
  }

  Future<void> _scheduleReminder(
          String id, String doctorName, DateTime start) =>
      NotificationsService.scheduleNotification(
        id: id.hashCode,
        scheduledTime: start.subtract(const Duration(days: 1)),
        title: 'Appointment reminder',
        body:
            '${Format.date(start)} at ${Format.time(start)} you have an appointment with $doctorName',
      );
}

final makeAppointmentScreenControllerProvider =
    AsyncNotifierProvider.autoDispose<MakeAppointmentScreenController, void>(
        () {
  return MakeAppointmentScreenController();
});
