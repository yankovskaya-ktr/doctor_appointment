import 'package:doctor_appointment/src/data/auth_repo.dart';

import 'src/domain/user.dart';
import 'src/presentation/patient_flow/appointments/appointmets_view.dart';
import 'src/presentation/patient_flow/appointments/doctors_list_screen.dart';
import 'src/presentation/patient_flow/appointments/make_appointment_screen.dart';

import 'src/presentation/doctor_flow/home_doctor/home_doctor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'src/presentation/auth/login_screen.dart';
import 'src/presentation/patient_flow/home_patient/home_patient_screen.dart';

GoRouter _goRouter(ProviderRef<GoRouter> ref) {
  final currentUser = ref.watch(currentUserProvider).asData?.value;

  return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        return currentUser == null
            ? '/login'
            : state.matchedLocation.startsWith('/login')
                ? currentUser.role == UserRole.doctor
                    ? '/homeDoctor'
                    : '/homePatient'
                : null;
      },
      routes: [
        GoRoute(
            name: LoginScreen.routeName,
            path: '/login',
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            }),
        GoRoute(
            name: HomePatientScreen.routeName,
            path: '/homePatient',
            builder: (BuildContext context, GoRouterState state) {
              return const HomePatientScreen();
            },
            routes: [
              GoRoute(
                  name: DoctorsListScreen.routeName,
                  path: 'doctors',
                  builder: (BuildContext context, GoRouterState state) {
                    return const DoctorsListScreen();
                  },
                  routes: [
                    GoRoute(
                        name: MakeAppointmentScreen.routeName,
                        path: ':doctorId/makeAppointment',
                        builder: (BuildContext context, GoRouterState state) {
                          final doctorId = state.pathParameters['doctorId'];
                          // final doctor = state.extra as AppUser;
                          return MakeAppointmentScreen(doctorId!);
                        })
                  ]),
              GoRoute(
                  name: AppointmentsView.routeName,
                  path: 'appointments',
                  builder: (BuildContext context, GoRouterState state) {
                    return const AppointmentsView();
                  })
            ]),
        GoRoute(
            name: HomeDoctorScreen.routeName,
            path: '/homeDoctor',
            builder: (BuildContext context, GoRouterState state) {
              return const HomeDoctorScreen();
            })
      ]);
}

final goRouterProvider = Provider<GoRouter>((ref) => _goRouter(ref));
