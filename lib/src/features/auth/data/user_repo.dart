import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../main.dart';
import '../domain/user.dart';
import 'user_repo_interface.dart';

class UserRepository implements UserRepoInterface {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  @override
  Future<String?> createAppUser(String id, String email, UserRole role) async {
    AppUser user = AppUser(email: email, role: role);
    try {
      _usersRef.doc(id).set(user.toMap());
      // Set default time slots
      if (role == UserRole.doctor) {
        addTimeSlots(id, AppUser.getDefaultTimeSlots());
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<AppUser?> getUserProfile(String id) async {
    AppUser? profile;
    try {
      var snapshot = await _usersRef.doc(id).get();
      if (snapshot.exists) {
        print('============ got user ${snapshot.data()!}');
        profile = AppUser.fromMap(snapshot.data()!, snapshot.id);
      }
    } catch (e) {
      print('Error getting user profile $id : $e');
    }
    return profile;
  }

  Future<String?> addTimeSlots(String id, List<DateTime> slots) async {
    try {
      _usersRef.doc(id).update({'timeSlots': FieldValue.arrayUnion(slots)});
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserRepository(firestore);
});
