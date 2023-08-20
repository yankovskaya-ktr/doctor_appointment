import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/src/domain/daily_slots.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../domain/user.dart';

class DoctorRepository {
  final FirebaseFirestore _firestore;

  DoctorRepository(this._firestore);

  CollectionReference<AppUser> get _usersRef =>
      _firestore.collection('users').withConverter(
            fromFirestore: (snapshot, _) =>
                AppUser.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (user, _) => user.toMap(),
          );

  Query<AppUser> queryAllDoctors() =>
      _usersRef.where('role', isEqualTo: UserRole.doctor.name);

  Future<AppUser> getDoctor(String id) async {
    final snapshot = await _usersRef.doc(id).get();
    return snapshot.data()!;
  }
}

final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return DoctorRepository(firestore);
});

final allDoctorsQueryProvider = Provider.autoDispose((ref) {
  final doctorRepo = ref.watch(doctorRepositoryProvider);
  return doctorRepo.queryAllDoctors();
});

final doctorProvider = FutureProvider.autoDispose.family<AppUser, String>(
  (ref, doctorId) async {
    final doctorRepo = ref.watch(doctorRepositoryProvider);
    return doctorRepo.getDoctor(doctorId);
  },
);

final dailyTimeSlotsProvider =
    Provider.autoDispose.family<List<DailyTimeSlots>, String>((ref, doctorId) {
  final doctor = ref.watch(doctorProvider(doctorId));
  if (doctor.asData != null) {
    return DailyTimeSlots.getAll(doctor.asData!.value.timeSlots!);
  }
  return [];
});
