import 'package:doctor_appointment/src/components/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/auth/auth_controller.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);

    String name = user.when(
      data: (user) => user!.name,
      error: (_, __) => '',
      loading: () => '',
    );

    final logOutButton = IconButton(
        onPressed: ref.read(authControllerProvider.notifier).signOut,
        icon: const Icon(Icons.logout));

    return Column(
      children: [
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          ProfileHeader(name: name),
          logOutButton,
        ]),
        const SizedBox(height: 24),
      ],
    );
  }
}
