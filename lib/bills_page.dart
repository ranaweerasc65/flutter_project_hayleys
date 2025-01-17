import 'package:flutter/material.dart';

class BillsPage extends StatelessWidget {
  const BillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills Page'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text('This is the Bills Page'),
      ),
    );
  }
}
