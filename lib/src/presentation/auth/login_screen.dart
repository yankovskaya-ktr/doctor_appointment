import 'package:doctor_appointment/src/data/auth_repo.dart';
import 'package:doctor_appointment/src/presentation/doctor_flow/home_doctor/home_doctor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../patient_flow/home_patient/home_patient_screen.dart';
import '../../domain/user.dart';
import 'login_screen_controller.dart';

class LoginScreen extends ConsumerWidget {
  static const String routeName = 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterLogin(
      onLogin: (LoginData data) => _loginUser(data, ref),
      onSignup: (SignupData data) => _signupUser(data, ref, context),
      onSubmitAnimationCompleted: () =>
          _onSubmitAnimationCompleted(context, ref),
      onRecoverPassword: (String name) => _recoverPassword(name),
      hideForgotPasswordButton: true,
      loginAfterSignUp: true,
    );
  }

  Future<String?> _signupUser(
      SignupData data, WidgetRef ref, BuildContext context) async {
    // Ask user to chose a role
    final UserRole? role = await showDialog<UserRole>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select your role, please:'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, UserRole.doctor);
              },
              child: const Text('I am a doctor'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, UserRole.patient);
              },
              child: const Text('I am a patient'),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );

    return ref
        .read(authControllerProvider.notifier)
        .createUserWithEmailAndPassword(
            email: data.name!, password: data.password!, role: role!);
  }

  Future<String?> _loginUser(LoginData data, WidgetRef ref) async {
    return ref
        .read(authControllerProvider.notifier)
        .signInWithEmailAndPassword(email: data.name, password: data.password);
  }

  Future<String?> _recoverPassword(String name) async {
    return null;
  }

  void _onSubmitAnimationCompleted(BuildContext context, WidgetRef ref) async {
    final currentUser = ref.watch(currentUserProvider);
    currentUser.when(
        data: (user) => user!.role == UserRole.doctor
            ? context.goNamed(HomeDoctorScreen.routeName)
            : context.goNamed(HomePatientScreen.routeName),
        error: (_, __) => context.goNamed(LoginScreen.routeName),
        loading: () => const CircularProgressIndicator());
  }
}
