import 'package:flutter/material.dart';

class OthersPage extends StatelessWidget {
  const OthersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Others Page'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text('This is the Others Page'),
      ),
    );
  }
}
