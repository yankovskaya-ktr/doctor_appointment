import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/user.dart';
import '../../components/avatar.dart';
import '../../../data/doctor_repo.dart';
import 'make_appointment_screen.dart';

class DoctorsListScreen extends StatelessWidget {
  static const String routeName = 'doctors';

  const DoctorsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Doctors'),
          centerTitle: true,
        ),
        body: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final doctorsQuery = ref.watch(allDoctorsQueryProvider);
            return FirestoreListView<AppUser>(
              query: doctorsQuery,
              itemBuilder: (context, doc) {
                AppUser doctor = doc.data();
                return GestureDetector(
                    onTap: () => {
                          context.pushNamed(
                            MakeAppointmentScreen.routeName,
                            pathParameters: {'doctorId': doctor.id!},
                          )
                        },
                    child: _DoctorItem(doctor));
              },
            );
          },
        ));
  }
}

class _DoctorItem extends StatelessWidget {
  final AppUser doctor;
  const _DoctorItem(this.doctor);

  @override
  Widget build(BuildContext context) {
    final name = Text(
      doctor.name,
      style: Theme.of(context).textTheme.titleMedium,
    );

    // hard code doctor's info except name
    final info = Text('Specialization\nAddress',
        style: Theme.of(context).textTheme.labelLarge);

    // final price = Text(
    //   '60 \$',
    //   style: TextStyle(
    //       fontSize: 16,
    //       fontWeight: FontWeight.bold,
    //       color: Theme.of(context).primaryColorDark),
    // );

    const arrowIcon = Icon(Icons.arrow_forward_ios);

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AvatarDefault(),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [name, info],
        ),
      ],
    );
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10)),
      // height: 150,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [content, arrowIcon],
      ),
    );
  }
}
