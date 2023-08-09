import 'package:flutter/material.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: const Center(
        child: Text(
          'Witaj, to jest zawartość mojej strony!',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
