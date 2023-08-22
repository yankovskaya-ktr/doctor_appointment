import 'package:doctor_appointment/src/presentation/doctor_flow/home_doctor/appointments_list.dart';
import 'package:flutter/material.dart';
import '../../components/home_header.dart';

class HomeDoctorScreen extends StatelessWidget {
  static const String routeName = 'homeDoctor';

  const HomeDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Column(children: [
              HomeHeader(),
              Expanded(child: _ScheduledAppointments()),
            ])));
  }
}

class _ScheduledAppointments extends StatelessWidget {
  const _ScheduledAppointments();

  @override
  Widget build(BuildContext context) {
    ('My Appointments', style: Theme.of(context).textTheme.titleLarge);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Appointments', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const AppointmentsListviewForDoctor(),
      ],
    );
  }
}
