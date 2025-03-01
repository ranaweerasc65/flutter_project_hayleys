// options.dart
import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/dashboard/components/tables/add_doctor.dart';

class OptionsDialog extends StatelessWidget {
  final Map<String, dynamic> illness;
  final TabController tabController;
  final int customerId;
  const OptionsDialog({
    super.key,
    required this.illness,
    required this.tabController,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.person_add, color: Colors.green),
          title: const Text('Add Doctors'),
          onTap: () {
            Navigator.pop(context);
            print("Click on Doctor Option");
          },
        ),
        ListTile(
          leading: const Icon(Icons.receipt_long, color: Colors.orange),
          title: const Text('Add Prescriptions'),
          onTap: () {
            Navigator.pop(context);
            print("Click on Prescriptions Option");
          },
        ),
        ListTile(
          leading: const Icon(Icons.insert_drive_file, color: Colors.purple),
          title: const Text('Add Reports'),
          onTap: () {
            Navigator.pop(context);
            print("Click on Reports Option");
          },
        ),
        ListTile(
          leading: const Icon(Icons.attach_money, color: Colors.teal),
          title: const Text('Add Bills'),
          onTap: () {
            Navigator.pop(context);
            print("Click on Bills Option");
          },
        ),
        ListTile(
          leading: const Icon(Icons.folder, color: Colors.brown),
          title: const Text('Add Other Documents'),
          onTap: () {
            Navigator.pop(context);
            print("Click on Other Documents Option");
          },
        ),
      ],
    );
  }

  // Static method to show the dialog
  static void show(
    BuildContext context, {
    required Map<String, dynamic> illness,
    required TabController tabController,
    required int customerId,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => OptionsDialog(
        illness: illness,
        tabController: tabController,
        customerId: customerId,
      ),
    );
  }
}
