import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repo.dart';

class SignOutButtonController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<void> signOut() async {
    final authRepo = ref.watch(authRepositoryProvider);
    return authRepo.signOut();
  }
}

final signOutButtonControllerProvider =
    AsyncNotifierProvider<SignOutButtonController, void>(() {
  return SignOutButtonController();
});
