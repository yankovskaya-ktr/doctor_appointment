import 'package:doctor_appointment/src/presentation/components/home_icon_button.dart';
import 'package:doctor_appointment/src/data/appointment_repo.dart';
import 'package:doctor_appointment/src/domain/appointment.dart';
import 'package:doctor_appointment/src/presentation/patient_flow/make_appointment/make_appointment_screen.dart';
import 'package:doctor_appointment/src/presentation/patient_flow/manage_appointment/manage_appointment_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/user_info.dart';
import '../../../utils/format.dart';
import '../home_patient/home_patient_screen.dart';

class ManageAppointmentScreen extends ConsumerWidget {
  static const String routeName = 'appointment';

  final String appointmentId;

  const ManageAppointmentScreen(this.appointmentId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentAsync = ref.watch(appointmentProvider(appointmentId));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Manage appointment'),
          centerTitle: true,
          actions: const [HomeIconButton()],
        ),
        body: appointmentAsync.when(
          data: (appointment) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _AppointmentInfo(appointment)),
          error: (error, _) => const Text('Error loading doctor data'),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}

class _AppointmentInfo extends StatelessWidget {
  final Appointment appointment;
  const _AppointmentInfo(this.appointment);

  @override
  Widget build(BuildContext context) {
    final date = Row(children: [
      const Icon(Icons.calendar_month),
      const SizedBox(width: 8),
      Text(
          '${Format.dateAndDayOfWeek(appointment.start)}, ${Format.time(appointment.start)}',
          style: Theme.of(context).textTheme.titleLarge)
    ]);

    final address = Row(children: [
      const Icon(Icons.location_on_outlined),
      const SizedBox(width: 8),
      Text('Address', style: Theme.of(context).textTheme.bodyLarge)
    ]);

    final approved = appointment.isApproved
        ? Row(children: [
            Icon(Icons.check, color: Colors.green[300]),
            const SizedBox(width: 8),
            Text('Confirmed by the doctor',
                style: TextStyle(
                    color: Colors.green[300],
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize))
          ])
        : Row(children: [
            Icon(Icons.warning_amber, color: Colors.amber[600]),
            const SizedBox(width: 8),
            Text('Not confirmed by the doctor',
                style: TextStyle(
                    color: Colors.amber[600],
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize))
          ]);

    return Column(
      children: [
        UserInfo(
          name: appointment.doctorName,
          specialization: 'Specialization',
        ),
        const SizedBox(height: 24),
        date,
        const SizedBox(height: 8),
        address,
        const SizedBox(height: 8),
        approved,
        const SizedBox(height: 24),
        _Buttons(appointment)
      ],
    );
  }
}

class _Buttons extends ConsumerWidget {
  final Appointment appointment;
  const _Buttons(this.appointment);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cancelButton = FilledButton.tonal(
        style: const ButtonStyle(
            fixedSize: MaterialStatePropertyAll(Size.fromWidth(150))),
        onPressed: () async {
          // Cancel appointment and return to home screen
          final success = await ref
              .read(manageAppointmentsScreenControllerProvider.notifier)
              .cancelAppointment(appointment);
          if (context.mounted) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text('Your appointment was cancelled successfully.')));
              context.goNamed(HomePatientScreen.routeName);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text('Something went wrong. Please, try again later.')));
            }
          }
        },
        child: const Text('Cancel'));

    final rescheduleButton = FilledButton.tonal(
        style: const ButtonStyle(
            fixedSize: MaterialStatePropertyAll(Size.fromWidth(150))),
        onPressed: () async {
          // Cancel this appointment and go to MakeApointment screen for the same doctor
          final success = await ref
              .read(manageAppointmentsScreenControllerProvider.notifier)
              .cancelAppointment(appointment);
          if (context.mounted) {
            if (success) {
              context.goNamed(
                MakeAppointmentScreen.routeName,
                pathParameters: {'doctorId': appointment.doctorId},
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text('Something went wrong. Please, try again later.')));
            }
          }
        },
        child: const Text('Reschedule'));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [rescheduleButton, cancelButton],
    );
  }
}
