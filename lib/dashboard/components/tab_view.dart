import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_project_hayleys/dashboard/components/tables/illness_table.dart';
import 'package:flutter_project_hayleys/dashboard/components/tables/doctor_table.dart';
import 'package:flutter_project_hayleys/dashboard/components/tables/bills_table.dart';
import 'package:flutter_project_hayleys/dashboard/components/tables/reports_table.dart';
import 'package:flutter_project_hayleys/dashboard/components/tables/prescriptions_table.dart';
import 'package:flutter_project_hayleys/dashboard/components/tables/others_table.dart';

class TabView extends StatefulWidget {
  final String tabName;
  final TabController tabController;
  final int customerId;
  final Function onDataUpdated;

  const TabView({
    super.key,
    required this.tabName,
    required this.tabController,
    required this.customerId,
    required this.onDataUpdated,
  });

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  Timer? _timer;
  int? selectedIllnessId;

  final List<String> tabNames = [
    'Illness',
    'Doctors',
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
      case 'Doctors':
        fetchDoctors();
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

  Future<void> fetchIllness() async {
    widget.onDataUpdated();
  }

  Future<void> fetchDoctors() async {
    widget.onDataUpdated();
  }

  Future<void> fetchBills() async {}
  Future<void> fetchPrescriptions() async {}
  Future<void> fetchReports() async {}
  Future<void> fetchOthers() async {}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void setSelectedIllnessId(int? illnessId) {
    setState(() {
      selectedIllnessId = illnessId;
    });
  }

  Widget getTableWidget() {
    switch (widget.tabName) {
      case 'Illness':
        return IllnessTable(
          customerId: widget.customerId,
          onIllnessAdded: (int? illnessId) {
            setSelectedIllnessId(illnessId);
            widget.onDataUpdated();
          },
          tabController: widget.tabController,
        );
      case 'Doctors':
        return DoctorTable(
          customerId: widget.customerId,
          illnessId: selectedIllnessId,
          onDoctorAdded: widget.onDataUpdated,
        );
      case 'Prescriptions':
        return PrescriptionsTable(
          customerId: widget.customerId,
          illnessId: selectedIllnessId,
          onPrescriptionAdded: widget.onDataUpdated,
        );
      case 'Reports':
        return ReportsTable(
          customerId: widget.customerId,
          illnessId: selectedIllnessId,
          onReportAdded: widget.onDataUpdated,
        );
      case 'Bills':
        return BillsTable(
          customerId: widget.customerId,
          illnessId: selectedIllnessId,
          onBillAdded: widget.onDataUpdated,
        );
      case 'Others':
        return OthersTable(
          customerId: widget.customerId,
          illnessId: selectedIllnessId,
          onOtherAdded: widget.onDataUpdated,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: getTableWidget()),
      ],
    );
  }
}
