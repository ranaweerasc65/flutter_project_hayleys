import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:flutter_project_hayleys/dashboard/components/tables/illness_table.dart';
import 'package:flutter_project_hayleys/dashboard/components/tables/bills_table.dart';
import 'package:flutter_project_hayleys/dashboard/components/tables/reports_table.dart';
import 'package:flutter_project_hayleys/dashboard/components/tables/prescriptions_table.dart';

class TabView extends StatefulWidget {
  final String tabName;

  const TabView({Key? key, required this.tabName}) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  List<dynamic> inquiries = [];
  List<dynamic> previousInquiries = []; // Store previous data for comparison
  Timer? _timer; // Timer for periodic updates

  @override
  void initState() {
    super.initState();
    if (widget.tabName == 'Illness') {
      fetchIllness();
    } else if (widget.tabName == 'Bills') {
      fetchBills();
    } else if (widget.tabName == 'Prescriptions') {
      fetchPrescriptions();
    } else if (widget.tabName == 'Reports') {
      fetchReports();
    }

    // Start a timer to periodically check for updates
    _startAutoRefresh();
  }

  // Start periodic data refresh
  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (widget.tabName == 'Illness') {
        fetchIllness();
      } else if (widget.tabName == 'Bills') {
        fetchBills();
      } else if (widget.tabName == 'Prescriptions') {
        fetchPrescriptions();
      } else if (widget.tabName == 'Reports') {
        fetchReports();
      }
    });
  }

  // Compare new data with previous data before updating the state
  void _updateInquiries(List<dynamic> newInquiries) {
    if (newInquiries.toString() != previousInquiries.toString()) {
      setState(() {
        inquiries = newInquiries;
        previousInquiries =
            newInquiries; // Update previous data for future comparison
      });
    }
  }

  Future<void> fetchIllness() async {}

  Future<void> fetchBills() async {}

  Future<void> fetchPrescriptions() async {}

  Future<void> fetchReports() async {}

  void _showNoDataWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No inquiries found for this user.'),
        backgroundColor: const Color.fromARGB(
            255, 227, 145, 4), // Set the color to orange for warning
        duration: Duration(seconds: 3), // Show the SnackBar for 3 seconds
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: widget.tabName == 'Illness'
                ? IllnessTable()
                : widget.tabName == 'Bills'
                    ? const BillsTable()
                    : widget.tabName == 'Prescriptions'
                        ? const PrescriptionsTable()
                        : widget.tabName == 'Reports'
                            ? const ReportsTable()
                            : Container(),
          ),
        ],
      ),
    );
  }
}
