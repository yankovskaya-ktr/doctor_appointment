import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repo.dart';
import 'signout_button_controller.dart';
import 'user_info.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    String name = user.when(
      data: (user) => user!.name,
      error: (_, __) => '',
      loading: () => '',
    );

    final signOutButton = IconButton(
        onPressed: ref.read(signOutButtonControllerProvider.notifier).signOut,
        icon: const Icon(Icons.logout));

    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).viewPadding.top + 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          UserInfo(name: name),
          signOutButton,
        ]),
        const SizedBox(height: 24),
      ],
    );
  }
}
