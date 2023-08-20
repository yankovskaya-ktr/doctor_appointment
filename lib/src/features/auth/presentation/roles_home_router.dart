// import 'package:doctor_appointment/src/features/auth/domain/user.dart';
// import 'package:doctor_appointment/src/features/doctor_flow/home_doctor/home_doctor.dart';
// import 'package:doctor_appointment/src/features/patient_flow/home_patient/home_patient.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// import 'auth_controller.dart';
// import 'login_view.dart';

// class RolesRouter extends StatefulWidget {
//   static const String routeName = '/';

//   const RolesRouter({super.key});

//   @override
//   State<RolesRouter> createState() => _RolesRouterState();
// }

// class _RolesRouterState extends State<RolesRouter> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }

//   late AuthController _authController;

//   @override
//   void initState() {
//     super.initState();
//     _authController = Provider.of<AuthController>(context, listen: false);
//     WidgetsBinding.instance.addPostFrameCallback((_) => checkIfAuthenticated());
//   }

//   Future<void> checkIfAuthenticated() async {
//     String route = LoginView.routeName;

//     if (mounted) {
//       if (_authController.currentUser != null) {
//         if (_authController.currentUser!.role == UserRole.doctor) {
//           route = HomeDoctor.routeName;
//         } else {
//           route = HomePatient.routeName;
//         }
//       }

//       if (context.mounted) {
//         context.goNamed(route);
//       }
//     }
//   }
// }
