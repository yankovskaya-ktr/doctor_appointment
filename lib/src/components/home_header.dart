import 'package:doctor_appointment/src/features/auth/presentation/app_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ClipOval(
        child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/avatar.jpg'),
              fit: BoxFit.cover,
            ))));

    final username =
        Text('John Doe', style: Theme.of(context).textTheme.headlineSmall);

    final logOutButton = IconButton(
        onPressed: ref.read(authControllerProvider.notifier).signOut,
        icon: const Icon(Icons.logout));

    return Column(
      children: [
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            image,
            const SizedBox(width: 12),
            username,
          ]),
          logOutButton,
        ]),
        const SizedBox(height: 24),
      ],
    );
  }
}
