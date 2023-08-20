import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repo.dart';
import '../../data/user_repo.dart';
import '../../domain/user.dart';

class AuthController extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    print('=========== authController build started');
    final userRepo = ref.watch(userRepositoryProvider);
    final authState = ref.watch(authStateChangesProvider);
    print(
        '============ authState.asData?.value?.uid = ${authState.asData?.value?.uid}');

    if (authState.asData?.value?.uid != null) {
      return userRepo.getUserProfile(authState.asData!.value!.uid);
    }
    return null;
  }

  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final authRepo = ref.watch(authRepositoryProvider);
    return authRepo.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<String?> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required UserRole role}) async {
    final authRepo = ref.watch(authRepositoryProvider);
    return authRepo.createUserWithEmailAndPassword(
        email: email, password: password, role: role);
  }

  Future<void> signOut() async {
    final authRepo = ref.watch(authRepositoryProvider);
    return authRepo.signOut();
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AppUser?>(() {
  return AuthController();
});
