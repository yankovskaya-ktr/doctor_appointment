import 'package:flutter/material.dart';

class AvatarDefault extends StatelessWidget {
  const AvatarDefault({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
        child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/avatar.jpg'),
              fit: BoxFit.cover,
            ))));
  }
}

class AvatarSmall extends StatelessWidget {
  const AvatarSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
        child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/avatar.jpg'),
              fit: BoxFit.cover,
            ))));
  }
}
