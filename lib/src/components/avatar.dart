import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key});

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
