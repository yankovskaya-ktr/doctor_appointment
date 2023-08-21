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
    // try {
    _usersRef.doc(id).set(user);
    // Set default time slots
    // if (role == UserRole.doctor) {
    //   _addTimeSlots(id, AppUser.getDefaultTimeSlots());
    // }
    //   return null;
    // } catch (e) {
    //   return e.toString();
    // }
  }

  Future<AppUser> getUserProfile(String id) async {
    // try {
    final snapshot = await _usersRef.doc(id).get();
    // if (snapshot.exists) {
    print('============ got user ${snapshot.data()!}');
    // }
    // } catch (e) {
    //   print('Error getting user profile $id : $e');
    // }
    return snapshot.data()!;
  }

  Future<void> _addTimeSlots(String id, List<DateTime> slots) async {
    _usersRef.doc(id).update({'timeSlots': FieldValue.arrayUnion(slots)});
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserRepository(firestore);
});
