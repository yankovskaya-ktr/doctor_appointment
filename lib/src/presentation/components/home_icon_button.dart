import 'package:doctor_appointment/src/domain/user.dart';
import 'package:doctor_appointment/src/presentation/doctor_flow/home_doctor/home_doctor_screen.dart';
import 'package:doctor_appointment/src/presentation/patient_flow/home_patient/home_patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/auth_repo.dart';

class HomeIconButton extends ConsumerWidget {
  const HomeIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).asData?.value;

    return IconButton(
        onPressed: () {
          if (currentUser != null) {
            currentUser.role == UserRole.doctor
                ? context.goNamed(HomeDoctorScreen.routeName)
                : context.goNamed(HomePatientScreen.routeName);
          }
        },
        icon: const Icon(Icons.person));
  }
}
