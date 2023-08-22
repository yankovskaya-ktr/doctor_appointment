import 'package:flutter/material.dart';

class CustomPlaceholder extends StatelessWidget {
  final Widget? child;
  const CustomPlaceholder({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: child,
    );
  }
}
