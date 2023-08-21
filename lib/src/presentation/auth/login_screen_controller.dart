import 'dart:async';
import 'package:doctor_appointment/src/data/doctor_repo.dart';
import 'package:doctor_appointment/src/data/user_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repo.dart';
import '../../domain/user.dart';

class LoginScreenController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final authRepo = ref.watch(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() =>
        authRepo.signInWithEmailAndPassword(email: email, password: password));
    if (state.hasError) {
      return state.error.toString();
    }
    return null;
  }

  Future<String?> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required UserRole role}) async {
    final authRepo = ref.watch(authRepositoryProvider);
    final userRepo = ref.watch(userRepositoryProvider);
    final doctorRepo = ref.watch(doctorRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userCreds = await authRepo.createUserWithEmailAndPassword(
          email: email, password: password, role: role);
      await userRepo.createAppUser(
          userCreds.user!.uid, userCreds.user!.email!, role);
      // Set default time slots
      if (role == UserRole.doctor) {
        await doctorRepo.addTimeSlots(
            userCreds.user!.uid, AppUser.getDefaultTimeSlots());
      }
    });
    if (state.hasError) {
      return state.error.toString();
    }
    return null;
  }

  Future<void> signOut() async {
    final authRepo = ref.watch(authRepositoryProvider);
    return authRepo.signOut();
  }
}

final authControllerProvider =
    AsyncNotifierProvider<LoginScreenController, void>(() {
  return LoginScreenController();
});
