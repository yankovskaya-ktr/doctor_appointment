import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/appointment_repo.dart';
import '../../../data/auth_repo.dart';
import '../../../domain/appointment.dart';
import '../../../utils/format.dart';
import '../appointments/manage_appointment_screen.dart';

class AppointmentsListview extends ConsumerWidget {
  const AppointmentsListview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    final appointmentsQuery =
        ref.watch(appointmentsForPatientQueryProvider(currentUser!.id!));

    return FirestoreListView(
      query: appointmentsQuery,
      itemBuilder: (context, doc) {
        final appointment = doc.data();
        return GestureDetector(
            onTap: () => {
                  context.pushNamed(
                    ManageAppointmentScreen.routeName,
                    pathParameters: {'appointmentId': appointment.id!},
                  )
                },
            child: _DayWithAppointmentsItem(appointment));
      },
      emptyBuilder: (context) => _CustomPlaceholder(
          child: Text(
        'You have no scheduled appointments.',
        style: Theme.of(context).textTheme.labelMedium,
      )),
      errorBuilder: (context, _, __) => _CustomPlaceholder(
          child: Text(
        'Error loading appointments.\nPlease come back later.',
        style: Theme.of(context).textTheme.labelMedium,
      )),
      loadingBuilder: (context) =>
          const _CustomPlaceholder(child: CircularProgressIndicator()),
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
    );
  }

  // @override
  // Widget build(BuildContext context, WidgetRef ref) {
  //   final appointments = ref.watch(appointmentsListControllerProvider);
  //   return appointments.when(
  //       data: (daysWithAppointments) => daysWithAppointments.isEmpty
  //           ? _CustomPlaceholder(
  //               child: Text(
  //               'You have no upkoming appointments',
  //               style: Theme.of(context).textTheme.labelMedium,
  //             ))
  //           : Expanded(
  //               child: ListView.builder(
  //                   itemCount: daysWithAppointments.length,
  //                   itemBuilder: (context, index) {
  //                     final dayWithAppointments = daysWithAppointments[index];
  //                     return _DayWithAppointmentsItem(dayWithAppointments);
  //                   })),
  //       error: (_, __) => _CustomPlaceholder(
  //               child: Text(
  //             'Error loading appointments.\nPlease come back later.',
  //             style: Theme.of(context).textTheme.labelMedium,
  //           )),
  //       loading: () =>
  //           const _CustomPlaceholder(child: CircularProgressIndicator()));
  // }
}

class _DayWithAppointmentsItem extends StatelessWidget {
  final Appointment appointment;

  const _DayWithAppointmentsItem(this.appointment);

  @override
  Widget build(BuildContext context) {
    // final date = Row(children: [
    //   const Icon(Icons.calendar_month),
    //   const SizedBox(width: 8),
    //   Text(
    //     '${Format.dateAndDayOfWeek(appointment.start)}\n${Format.time(appointment.start)}',
    //     style: Theme.of(context).textTheme.titleMedium,
    //   ),
    // ]);

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
        const SizedBox(height: 8),
        const Icon(Icons.open_in_new, color: Colors.black54),
      ],
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Specialization', style: Theme.of(context).textTheme.bodyLarge),
        Text(
          '${appointment.doctorName}\nAddress',
          style: Theme.of(context).textTheme.labelLarge,
        ),
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

class _CustomPlaceholder extends StatelessWidget {
  final Widget? child;
  const _CustomPlaceholder({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10)),
      // height: 150,
      constraints: const BoxConstraints.expand(height: 150),
      alignment: Alignment.center,
      child: child,
    );
  }
}
