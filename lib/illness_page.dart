import 'package:flutter/material.dart';

class IllnessPage extends StatelessWidget {
  const IllnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Illness Page'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text('This is the Illness Page'),
      ),
    );
  }
}
