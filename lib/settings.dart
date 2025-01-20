import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final int customerId;

  const SettingsPage({super.key, required this.customerId});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();

    print('SETTINGS SCREEN ');
    print('Customer ID: ${widget.customerId}');
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Settings Page',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
