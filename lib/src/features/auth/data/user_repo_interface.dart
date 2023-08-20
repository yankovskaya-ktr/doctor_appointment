import 'package:doctor_appointment/src/features/auth/domain/user.dart';

abstract class UserRepoInterface {
  Future<String?> createAppUser(String id, String email, UserRole role);
  Future<AppUser?> getUserProfile(String uid);
}
