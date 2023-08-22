import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../components/home_header.dart';

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
              // Expanded(child: _ScheduledAppointments()),
            ])));
  }
}

// class _ScheduledAppointments extends StatelessWidget {
//   const _ScheduledAppointments();

//   @override
//   Widget build(BuildContext context) {
//     final title =
//         Text('My Appointments', style: Theme.of(context).textTheme.titleLarge);

//     final addButton = TextButton.icon(
//         onPressed: () => context.pushNamed(DoctorsListScreen.routeName),
//         label: const Text('New'),
//         icon: const Icon(
//           Icons.add,
//         ));

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [title, addButton]),
//         const AppointmentsListview(),
//       ],
//     );
//   }
// }
