import 'package:doctor_appointment/src/data/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/user.dart';

class AuthRepository {
  final FirebaseAuth _authInstance;

  AuthRepository(this._authInstance);

  Stream<User?> authStateChanges() => _authInstance.authStateChanges();

  Future<UserCredential> createUserWithEmailAndPassword(
          {required String email,
          required String password,
          required UserRole role}) =>
      _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  Future<void> signOut() async {
    await _authInstance.signOut();
  }
}

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthRepository(auth); //, userRepo);
});

final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  print('=========== currentUserProvider rebuild started');
  final authenticatedUser = ref.watch(authStateChangesProvider).asData?.value;
  final userRepo = ref.watch(userRepositoryProvider);
  if (authenticatedUser != null) {
    print(
        '============ authState.asData?.value?.uid = ${authenticatedUser.uid}');
    return userRepo.getUserProfile(authenticatedUser.uid);
  }
  return null;
});
