import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_project_hayleys/dashboard/components/tables/illness_table.dart';
import 'package:flutter_project_hayleys/dashboard/components/tables/bills_table.dart';
import 'package:flutter_project_hayleys/dashboard/components/tables/reports_table.dart';
import 'package:flutter_project_hayleys/dashboard/components/tables/prescriptions_table.dart';
import 'package:flutter_project_hayleys/dashboard/components/tables/others_table.dart';

class TabView extends StatefulWidget {
  final String tabName;
  final TabController tabController;
  final int customerId;

  const TabView(
      {Key? key,
      required this.tabName,
      required this.tabController,
      required this.customerId})
      : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  List<dynamic> inquiries = [];
  List<dynamic> previousInquiries = []; // Store previous data for comparison
  Timer? _timer; // Timer for periodic updates

  final List<String> tabNames = [
    'Illness',
    'Prescriptions',
    'Reports',
    'Bills',
    'Others'
  ];

  @override
  void initState() {
    super.initState();
    fetchDataForTab(widget.tabName);
    _startAutoRefresh();
  }

  // Start periodic data refresh
  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      fetchDataForTab(widget.tabName);
    });
  }

  void fetchDataForTab(String tabName) {
    switch (tabName) {
      case 'Illness':
        fetchIllness();
        break;
      case 'Prescriptions':
        fetchPrescriptions();
        break;
      case 'Reports':
        fetchReports();
        break;
      case 'Bills':
        fetchBills();
        break;
      case 'Others':
        fetchOthers();
        break;
    }
  }

  Future<void> fetchIllness() async {}
  Future<void> fetchBills() async {}
  Future<void> fetchPrescriptions() async {}
  Future<void> fetchReports() async {}
  Future<void> fetchOthers() async {}

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Widget getTableWidget() {
    switch (widget.tabName) {
      case 'Illness':
        return IllnessTable(
          customerId: widget.customerId,
        );
      case 'Prescriptions':
        return const PrescriptionsTable();
      case 'Reports':
        return const ReportsTable();
      case 'Bills':
        return const BillsTable();
      case 'Others':
        return const OthersTable();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Expanded(child: getTableWidget()),
        ],
      ),
    );
  }
}
