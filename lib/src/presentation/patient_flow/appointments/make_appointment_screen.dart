import 'package:doctor_appointment/src/components/profile_header.dart';
import 'package:doctor_appointment/src/data/doctor_repo.dart';
import 'package:doctor_appointment/src/domain/daily_slots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/format.dart';

class MakeAppointmentScreen extends StatelessWidget {
  static const String routeName = 'makeAppointment';

  // final AppUser doctor;
  final String doctorId;

  const MakeAppointmentScreen(this.doctorId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Make appointment'),
          centerTitle: true,
        ),
        body: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final doctorAsync = ref.watch(doctorProvider(doctorId));
          return doctorAsync.when(
            data: (doctor) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    ProfileHeader(
                      name: doctor.name,
                      specialization: 'Specialization',
                    ),
                    const SizedBox(height: 12),
                    Expanded(child: _TimeSlotsListView(doctorId)),
                  ],
                )),
            error: (error, _) => const Text('Error loading doctor data'),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }));

    // Consumer(
    //   builder: (BuildContext context, WidgetRef ref, Widget? child) {
    //     return Container();
    //   },
    // ));
  }
}

class _TimeSlotsListView extends ConsumerWidget {
  final String doctorId;

  const _TimeSlotsListView(this.doctorId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysWithSlots = ref.watch(dailyTimeSlotsProvider(doctorId));
    return ListView.builder(
      itemCount: daysWithSlots.length,
      itemBuilder: (context, index) {
        DailyTimeSlots dayWithSlots = daysWithSlots[index];
        return _DayItem(dayWithSlots);
      },
    );
  }
}

class _DayItem extends StatelessWidget {
  final DailyTimeSlots dayWithSlots;

  const _DayItem(this.dayWithSlots);

  @override
  Widget build(BuildContext context) {
    final day = dayWithSlots.day;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Format.dateAndDayOfWeek(day),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 4),
        _ButtonsForSlots(dayWithSlots.slots),
      ],
    );

    return Container(
      decoration: BoxDecoration(
          // color: Theme.of(context).primaryColorLight,
          border: Border.all(color: Theme.of(context).primaryColorLight),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: content,
    );
  }
}

class _ButtonsForSlots extends ConsumerWidget {
  final List<DateTime> slots;
  const _ButtonsForSlots(this.slots);

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
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
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
