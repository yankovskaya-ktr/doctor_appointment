import 'package:doctor_appointment/src/features/auth/domain/user.dart';

import 'src/features/auth/presentation/app_user_controller.dart';
import 'src/features/doctor_flow/home_doctor/home_doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'src/features/auth/presentation/login_view.dart';
import 'src/features/appointments/presentation/appointmets_view.dart';
import 'src/features/patient_flow/home_patient/home_patient_view.dart';

GoRouter _goRouter(ProviderRef<GoRouter> ref) {
  final authController = ref.watch(authControllerProvider);

  return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        return authController.when(
            data: (appUser) => appUser == null
                ? '/login'
                : appUser.role == UserRole.doctor
                    ? '/homeDoctor'
                    : '/homePatient',
            error: (_, __) => '/login',
            loading: () => '/login');
      },
      routes: [
        GoRoute(
            name: LoginView.routeName,
            path: '/login',
            builder: (BuildContext context, GoRouterState state) {
              return const LoginView();
            }),
        GoRoute(
            name: HomePatientView.routeName,
            path: '/homePatient',
            builder: (BuildContext context, GoRouterState state) {
              return const HomePatientView();
            },
            routes: [
              GoRoute(
                  name: AppointmentsView.routeName,
                  path: 'appointments',
                  builder: (BuildContext context, GoRouterState state) {
                    return const AppointmentsView();
                  })
            ]),
        GoRoute(
            name: HomeDoctor.routeName,
            path: '/homeDoctor',
            builder: (BuildContext context, GoRouterState state) {
              return const HomeDoctor();
            })
      ]);
}

final goRouterProvider = Provider<GoRouter>((ref) => _goRouter(ref));
