import 'package:flutter/material.dart';

class DoctorsListView extends StatelessWidget {
  static const String routeName = 'doctors';

  const DoctorsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Doctors'),
          centerTitle: true,
          // actions: [_addButton(context)],
        ),
        body: ListView.builder(
            itemBuilder: (context, index) => Container(height: 20)));
  }
}
