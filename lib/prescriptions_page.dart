import 'package:flutter/material.dart';

class PrescriptionsPage extends StatelessWidget {
  const PrescriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescriptions Page'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text('This is the Prescriptions Page'),
      ),
    );
  }
}
