import 'dart:async';
import 'package:doctor_appointment/src/domain/appointment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/appointment_repo.dart';

class AppointmentsListController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<bool> confirmAppointment(Appointment appointment) async {
    final appointmentRepo = ref.watch(appointmentRepositoryProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      appointmentRepo.confirmAppointment(appointment.id!);
    });

    return state.hasError == false;
  }
}

final appointmentsListControllerProvider =
    AsyncNotifierProvider.autoDispose<AppointmentsListController, void>(() {
  return AppointmentsListController();
});
