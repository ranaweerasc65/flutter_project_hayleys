import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/dashboard/components/bottom_navbar.dart';
import 'package:flutter_project_hayleys/dashboard/components/tab_view.dart';
import '../config.dart';
import '../insurance/insurance_card.dart';
import '../settings.dart';
import '../profile/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  final String userName;
  final String phoneNo;
  final int customerId;

  const Dashboard(
      {super.key,
      required this.userName,
      required this.phoneNo,
      required this.customerId});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  late final List<Widget> _pages;
  late TabController _tabController;

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

    print('DASHBOARD SCREEN');

    print('Customer ID: ${widget.customerId}');
    print(widget.phoneNo);
    _tabController = TabController(length: tabNames.length, vsync: this);

    _pages = [
      DashboardContent(
        userName: widget.userName,
        phoneNo: widget.phoneNo,
        customerId: widget.customerId,
      ),
      ProfilePage(customerId: widget.customerId),
      InsuranceCardPage(customerId: widget.customerId, phoneNo: widget.phoneNo),
      SettingsPage(customerId: widget.customerId),
    ];
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class DashboardContent extends StatefulWidget {
  final String userName;
  final String phoneNo;
  final int customerId;

  const DashboardContent(
      {super.key,
      required this.userName,
      required this.phoneNo,
      required this.customerId});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent>
    with SingleTickerProviderStateMixin {
  String firstName = '';
  String lastName = '';

  int illnessCount = 0;
  int DoctorsCount = 0;
  int billsCount = 0;
  int prescriptionsCount = 0;
  int reportsCount = 0;
  int othersCount = 0;

  Timer? _timer;

  late TabController _tabController;

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

    _fetchCustomerDetails();
    _fetchCounts();
    _startAutoRefresh();
    _tabController = TabController(length: tabNames.length, vsync: this);
  }

  Future<void> _fetchCustomerDetails() async {
    try {
      final url = Uri.parse(
          "${Config.baseUrl}get_First&LastNames.php?customer_id=${widget.customerId}");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("Response Body: ${response.body}");
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            firstName = data['first_name'];
            lastName = data['last_name'];
          });
        } else {
          // print("Error from server: ${data['message']}");
        }
      } else {
        // print('Error: Server returned status code ${response.statusCode}');
      }
    } catch (e) {
      // print('Error fetching customer details: $e');
    }
  }

  Future<void> _fetchCounts() async {
    await _fetchIllnessCount(widget.customerId);
    await _fetchDoctorsCount(widget.customerId);
    await _fetchBillsCount();
    await _fetchPrescriptionsCount();
    await _fetchReportsCount();
    await _fetchOthersCount();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      //_fetchCounts(); // Call the fetch function every 30 seconds
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchIllnessCount(int customerId) async {
    final url = Uri.parse(
        "${Config.baseUrl}get_illness_count.php?customer_id=${widget.customerId}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            illnessCount = data['illness_count'];
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching illness count: $e');
    }
  }

  Future<void> _fetchDoctorsCount(int customerId) async {
    final url = Uri.parse(
        "${Config.baseUrl}get_doctor_count.php?customer_id=${widget.customerId}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            illnessCount = data['doctor_count'];
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching doctor count: $e');
    }
  }

  Future<void> _fetchBillsCount() async {
    //print("_fetchBillsCount");
  }

  Future<void> _fetchPrescriptionsCount() async {
    //print("_fetchPrescriptionsCount");
  }

  Future<void> _fetchReportsCount() async {
    //print("_fetchReportsCount");
  }

  Future<void> _fetchOthersCount() async {
    //print("_fetchOthersCount");
  }

  void _refreshIllnessCount() {
    _fetchIllnessCount(
        widget.customerId); // Refresh illness count (implement this function)
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '$firstName $lastName',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.blue.shade800,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  // Add any action for the Cancel button if needed
                },
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.local_hospital),
                    text: 'Illness ($illnessCount)',
                  ),
                  Tab(
                    icon: const Icon(Icons.man),
                    text: 'Doctors ($DoctorsCount)',
                  ),
                  Tab(
                    icon: const Icon(Icons.medication),
                    text: 'Prescriptions ($prescriptionsCount)',
                  ),
                  Tab(
                    icon: const Icon(Icons.assessment),
                    text: 'Reports ($reportsCount)',
                  ),
                  Tab(
                    icon: const Icon(Icons.receipt_long),
                    text: 'Bills ($billsCount)',
                  ),
                  Tab(
                    icon: const Icon(Icons.document_scanner_rounded),
                    text: 'Others ($othersCount)',
                  ),
                ],
                labelColor: Colors.blue.shade800,
                unselectedLabelColor: const Color.fromARGB(179, 144, 141, 141),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    TabView(
                      tabName: 'Illness',
                      tabController: _tabController,
                      customerId: widget.customerId,
                      onDataUpdated: _refreshIllnessCount,
                    ),
                    TabView(
                      tabName: 'Doctors',
                      tabController: _tabController,
                      customerId: widget.customerId,
                      onDataUpdated: _refreshIllnessCount,
                    ),
                    TabView(
                      tabName: 'Prescriptions',
                      tabController: _tabController,
                      customerId: widget.customerId,
                      onDataUpdated: _refreshIllnessCount,
                    ),
                    TabView(
                      tabName: 'Reports',
                      tabController: _tabController,
                      customerId: widget.customerId,
                      onDataUpdated: _refreshIllnessCount,
                    ),
                    TabView(
                      tabName: 'Bills',
                      tabController: _tabController,
                      customerId: widget.customerId,
                      onDataUpdated: _refreshIllnessCount,
                    ),
                    TabView(
                      tabName: 'Others',
                      tabController: _tabController,
                      customerId: widget.customerId,
                      onDataUpdated: _refreshIllnessCount,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
