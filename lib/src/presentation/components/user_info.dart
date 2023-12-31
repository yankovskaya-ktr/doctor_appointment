import 'package:flutter/material.dart';

import 'avatar.dart';

class UserInfo extends StatelessWidget {
  final String name;
  final String? specialization;

  const UserInfo({super.key, required this.name, this.specialization});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const AvatarDefault(),
      const SizedBox(width: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.headlineSmall),
          if (specialization != null)
            Text(specialization!, style: Theme.of(context).textTheme.bodyLarge)
        ],
      )
    ]);
  }
}
