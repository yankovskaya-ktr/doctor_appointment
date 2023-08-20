import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppointmentController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> makeAppointment() async {}
}

final appointmentControllerProvider =
    AsyncNotifierProvider<AppointmentController, void>(() {
  return AppointmentController();
});
