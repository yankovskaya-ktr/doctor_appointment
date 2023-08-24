import 'package:doctor_appointment/src/presentation/doctor_flow/home_doctor/appointments_list_controller.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/appointments_placeholder.dart';
import '../../../data/appointment_repo.dart';
import '../../../data/auth_repo.dart';
import '../../../domain/appointment.dart';
import '../../../utils/format.dart';

class AppointmentsListviewForDoctor extends ConsumerWidget {
  const AppointmentsListviewForDoctor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    final appointmentsQuery =
        ref.watch(appointmentsForDoctorQueryProvider(currentUser!.id!));

    return SizedBox(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.bottom -
          MediaQuery.of(context).viewPadding.top -
          160,
      child: FirestoreListView(
        query: appointmentsQuery,
        itemBuilder: (context, doc) {
          final appointment = doc.data();
          return _AppointmentItem(appointment);
        },
        emptyBuilder: (context) => CustomPlaceholder(
            child: Text(
          'You have no scheduled appointments.',
          style: Theme.of(context).textTheme.labelMedium,
        )),
        errorBuilder: (context, _, __) => CustomPlaceholder(
            child: Text(
          'Error loading appointments.\nPlease come back later.',
          style: Theme.of(context).textTheme.labelMedium,
        )),
        loadingBuilder: (context) =>
            const CustomPlaceholder(child: CircularProgressIndicator()),
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
      ),
    );
  }
}

class _AppointmentItem extends ConsumerWidget {
  final Appointment appointment;

  const _AppointmentItem(this.appointment);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(children: [
          const Icon(Icons.calendar_month),
          const SizedBox(width: 8),
          Text(
            Format.dateAndDayOfWeek(appointment.start),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ]),
        Text(
          Format.time(appointment.start),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );

    final confirmButton = ElevatedButton.icon(
        onPressed: () => ref
            .read(appointmentsListControllerProvider.notifier)
            .confirmAppointment(appointment),
        icon: const Icon(Icons.check),
        label: const Text('Confirm'));

    final approved = appointment.isApproved
        ? Row(children: [
            Icon(Icons.check, color: Theme.of(context).primaryColor),
            const SizedBox(width: 4),
            Text('Confirmed',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500))
          ])
        : confirmButton;

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(appointment.patientName,
            style: Theme.of(context).textTheme.bodyLarge),
        Text('Address', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 12),
        approved,
      ],
    );

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [info, date],
      ),
    );
  }
}
