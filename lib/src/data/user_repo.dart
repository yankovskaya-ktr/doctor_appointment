import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../domain/user.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  CollectionReference<AppUser> get _usersRef =>
      _firestore.collection('users').withConverter(
            fromFirestore: (snapshot, _) =>
                AppUser.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (user, _) => user.toMap(),
          );

  Future<void> createAppUser(String id, String email, UserRole role) async {
    // hard-code default name of a new user
    AppUser user = AppUser(email: email, role: role, name: 'John Doe');
    _usersRef.doc(id).set(user);
  }

  Future<AppUser> getUserProfile(String id) async {
    final snapshot = await _usersRef.doc(id).get();
    print('============ got user ${snapshot.data()!}');
    return snapshot.data()!;
  }

  // add token for notifications
  Future<void> addFCMToken(String id, String token) async {
    _usersRef.doc(id).update({
      'notificationTokens': FieldValue.arrayUnion([token])
    });
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserRepository(firestore);
});
