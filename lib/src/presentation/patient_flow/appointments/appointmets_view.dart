import 'package:flutter/material.dart';

class AppointmentsView extends StatelessWidget {
  static const String routeName = 'appointments';

  const AppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My appointments'),
          centerTitle: true,
          actions: [_addButton(context)],
        ),
        body: ListView());
  }

  List<Widget> _renderBody(BuildContext context) {
    return [];
  }

  Widget _addButton(BuildContext context) {
    return IconButton(onPressed: () => {}, icon: const Icon(Icons.add));
  }
}
