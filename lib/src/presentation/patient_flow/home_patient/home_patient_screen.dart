import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../components/home_header.dart';
import '../make_appointment/doctors_list_screen.dart';
import 'appointments_list.dart';

class HomePatientScreen extends StatelessWidget {
  static const String routeName = 'homePatient';

  const HomePatientScreen({super.key});

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
    final title =
        Text('My Appointments', style: Theme.of(context).textTheme.titleLarge);

    final addButton = TextButton.icon(
        onPressed: () => context.pushNamed(DoctorsListScreen.routeName),
        label: const Text('New'),
        icon: const Icon(
          Icons.add,
        ));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [title, addButton]),
        const AppointmentsListviewForPatient(),
      ],
    );
  }
}
