import 'package:doctor_appointment/src/components/home_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../appointments/presentation/appointmets_view.dart';

class HomePatientView extends StatelessWidget {
  static const String routeName = 'homePatient';

  const HomePatientView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(children: _renderBody(context))));
  }

  List<Widget> _renderBody(BuildContext context) {
    return [
      const HomeHeader(),
      const _NearestAppointments(),
    ];
  }
}

class _NearestAppointments extends StatelessWidget {
  const _NearestAppointments();

  @override
  Widget build(BuildContext context) {
    final title = Text('Nearest Appointments',
        style: Theme.of(context).textTheme.titleLarge);

    final allButton = TextButton.icon(
        onPressed: () => context.pushNamed(AppointmentsView.routeName),
        label: const Text('View all'),
        icon: const Icon(
          Icons.view_agenda_outlined,
        ));

    final addButton = TextButton.icon(
        onPressed: () => context.pushNamed(AppointmentsView.routeName),
        label: const Text('New appointment'),
        icon: const Icon(
          Icons.add,
        ));

    final buttons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [addButton, allButton],
    );

    final content = Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10)),
      height: 150,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, const SizedBox(height: 12), content, buttons],
    );
  }
}
