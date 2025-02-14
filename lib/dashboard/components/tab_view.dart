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

  const TabView({Key? key, required this.tabName, required this.tabController})
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
        return const IllnessTable();
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
    int currentIndex = tabNames.indexOf(widget.tabName);
    int lastIndex = tabNames.length - 1;

    // return Padding(
    //   padding: const EdgeInsets.all(16.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const SizedBox(height: 20),
    //       Expanded(child: getTableWidget()),
    //     ],
    //   ),
    // );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Expanded(child: getTableWidget()),

          // Navigation buttons
          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentIndex > 0)
                ElevatedButton(
                  onPressed: () =>
                      widget.tabController.animateTo(currentIndex - 1),
                  child: const Text('Back'),
                ),
              if (currentIndex < lastIndex)
                Positioned(
                  bottom: 16, // Positioning from the bottom of the screen
                  right: 16, // Positioning from the right of the screen
                  child: ElevatedButton(
                    onPressed: () =>
                        widget.tabController.animateTo(currentIndex + 1),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.blue.shade800, // Use non-constant expression
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.white, // Button background color (white)
                      side: BorderSide(
                        color: Colors.blue
                            .shade800, // Button border color (blue shade 800)
                        width: 2, // Border width
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0, // No shadow
                    ),
                  ),
                ),
              if (currentIndex == lastIndex)
                ElevatedButton(
                  onPressed: () {
                    // Implement save functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Data saved successfully!")),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child:
                      const Text('Save', style: TextStyle(color: Colors.white)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
