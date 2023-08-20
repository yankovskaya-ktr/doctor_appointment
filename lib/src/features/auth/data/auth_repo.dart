import 'package:doctor_appointment/src/features/auth/data/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/user.dart';

class AuthRepository {
  final FirebaseAuth _authInstance;
  final UserRepository _userRepo;

  AuthRepository(this._authInstance, this._userRepo);

  Stream<User?> authStateChanges() => _authInstance.authStateChanges();

  Future<String?> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required UserRole role}) async {
    try {
      await _authInstance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((userCreds) => _userRepo.createAppUser(
              userCreds.user!.uid, userCreds.user!.email!, role));
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _authInstance.signOut();
  }
}

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  return AuthRepository(auth, userRepo);
});

final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

// final currentUserProvider = Provider<AppUser?>((ref) {
//   final auth = ref.watch(authStateChangesProvider);
//   final userRepo = ref.watch(userRepositoryProvider);

//   if (auth.asData?.value?.uid != null) {
//     return userRepo.getUserProfile(auth.asData!.value!.uid);
//   }
//   // else we return null
//   return null;
// });
