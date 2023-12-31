import 'make_appointment_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/doctor_repo.dart';
import '../../../domain/daily_slots.dart';
import '../../../domain/user.dart';
import '../../../utils/format.dart';
import '../../components/home_icon_button.dart';
import '../../components/user_info.dart';
import '../manage_appointment/manage_appointment_screen.dart';

class MakeAppointmentScreen extends ConsumerWidget {
  static const String routeName = 'makeAppointment';

  final String doctorId;

  const MakeAppointmentScreen(this.doctorId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorAsync = ref.watch(doctorProvider(doctorId));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Make appointment'),
          centerTitle: true,
          actions: const [HomeIconButton()],
        ),
        body: doctorAsync.when(
          data: (doctor) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  UserInfo(
                    name: doctor.name,
                    specialization: 'Specialization',
                  ),
                  const SizedBox(height: 12),
                  Expanded(child: _TimeSlotsListView(doctor)),
                ],
              )),
          error: (error, _) => const Text('Error loading doctor data'),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}

class _TimeSlotsListView extends ConsumerWidget {
  final AppUser doctor;

  const _TimeSlotsListView(this.doctor);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysWithSlots = ref.watch(dailyTimeSlotsProvider(doctor.id!));
    return ListView.builder(
        itemCount: daysWithSlots.length,
        itemBuilder: (context, index) {
          DailyTimeSlots dayWithSlots = daysWithSlots[index];
          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Format.dateAndDayOfWeek(dayWithSlots.day),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              _ButtonsForSlots(dayWithSlots.slots, doctor),
            ],
          );

          return Container(
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColorLight),
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 8.0),
            child: content,
          );
        });
  }
}

class _ButtonsForSlots extends ConsumerWidget {
  final List<DateTime> slots;
  final AppUser doctor;
  const _ButtonsForSlots(this.slots, this.doctor);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeButtons = slots.map((DateTime slot) {
      return FilledButton.tonal(
        style: ButtonStyle(
          textStyle:
              MaterialStatePropertyAll(Theme.of(context).textTheme.labelMedium),
          padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 20)),
        ),
        onPressed: () => showDialog(
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Confirm Appointment'),
            content: Text(
              '${Format.dateAndDayOfWeek(slot)}, ${Format.time(slot)}',
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // listen for the provider until the future is complete: workaround to prevent exception "Future already completed"
                  // on updating provider's state after the provider is disposed (see discussion https://github.com/rrousselGit/riverpod/discussions/2502 )
                  final tempSubscription = ref.listenManual(
                      makeAppointmentScreenControllerProvider.notifier,
                      (_, __) {});
                  final newAppointmentId = await ref
                      .read(makeAppointmentScreenControllerProvider.notifier)
                      .makeAppointment(doctor: doctor, start: slot);
                  tempSubscription.close();

                  if (context.mounted) {
                    if (newAppointmentId != null) {
                      context.goNamed(
                        ManageAppointmentScreen.routeName,
                        pathParameters: {'appointmentId': newAppointmentId},
                      );
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Something went wrong. Please, try again later.')));
                    }
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
          context: context,
        ),
        child: Text(Format.time(slot)),
      );
    }).toList();

    return Wrap(spacing: 4, children: timeButtons);
  }
}
