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
    'Prescriptions',
    'Reports',
    'Bills',
    'Others'
  ];

  @override
  void initState() {
    super.initState();

    print('DASHBOARD SCREEN');

    // Print the customerId here
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

  void _nextTab() {
    if (_tabController.index < tabNames.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  void _previousTab() {
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
    }
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
  int billsCount = 0;
  int prescriptionsCount = 0;
  int reportsCount = 0;
  int othersCount = 0;

  Timer? _timer; // Declare a Timer

  late TabController _tabController;

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
    // Call the fetch method to retrieve customer details
    _fetchCustomerDetails();
    _fetchCounts(); // Initial fetch
    _startAutoRefresh(); // Start auto-refreshing
    _tabController = TabController(length: tabNames.length, vsync: this);
  }

  Future<void> _fetchCustomerDetails() async {
    // print("Starting _fetchCustomerDetails...");
    //print("Customer ID: ${widget.customerId}");

    try {
      // final url = Uri.parse(
      //     'http://172.16.200.79/flutter_project_hayleys/php/get_First&LastNames.php?customer_id=${widget.customerId}');
      final url = Uri.parse(
          "${Config.baseUrl}get_First&LastNames.php?customer_id=${widget.customerId}");
      // print("Constructed URL: $url");

      // Sending the GET request
      final response = await http.get(url);
      //  print("HTTP GET request sent.");

      // Checking the status code
      //print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Response Body: ${response.body}");
        final data = jsonDecode(response.body);

        // Checking the JSON structure
        //print("Parsed Response Data: $data");

        if (data['status'] == 'success') {
          //print("Successfully fetched customer details.");
          setState(() {
            firstName = data['first_name'];
            lastName = data['last_name'];
          });
          //print("Updated state: firstName=$firstName, lastName=$lastName");
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

// Function to fetch all counts
  Future<void> _fetchCounts() async {
    await _fetchIllnessCount();
    await _fetchBillsCount();
    await _fetchPrescriptionsCount();
    await _fetchReportsCount();
    await _fetchOthersCount();
  }

  // Function to periodically refresh the counts
  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      //_fetchCounts(); // Call the fetch function every 30 seconds
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  Future<void> _fetchIllnessCount() async {
    print("_fetchIllnessCount");
  }

  Future<void> _fetchBillsCount() async {
    print("_fetchBillsCount");
  }

  Future<void> _fetchPrescriptionsCount() async {
    print("_fetchPrescriptionsCount");
  }

  Future<void> _fetchReportsCount() async {
    print("_fetchReportsCount");
  }

  Future<void> _fetchOthersCount() async {
    print("_fetchOthersCount");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
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

        // Adding space before the TabBar
        body: Column(
          children: [
            const SizedBox(height: 10),

            // TabBar section displayed below AppBar
            Container(
              color: const Color.fromARGB(255, 255, 255,
                  255), // Optional, change the background color of the TabBar container
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.local_hospital),
                    text: 'Illness ($illnessCount)',
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

            // TabBarView section below the TabBar
            // Expanded(
            //   child: Container(
            //     color: Colors
            //         .white, // Ensure this section has a pure white background
            //     child: const TabBarView(
            //       children: [
            //         TabView(tabName: 'Illness'),
            //         TabView(tabName: 'Prescriptions'),
            //         TabView(tabName: 'Reports'),
            //         TabView(tabName: 'Bills'),
            //         TabView(tabName: 'Others'),
            //       ],
            //     ),
            //   ),
            // )

            Expanded(
              child: Container(
                color: Colors.white,
                child: TabBarView(
                  controller: _tabController, // <-- Pass the controller here
                  children: [
                    TabView(tabName: 'Illness', tabController: _tabController),
                    TabView(
                        tabName: 'Prescriptions',
                        tabController: _tabController),
                    TabView(tabName: 'Reports', tabController: _tabController),
                    TabView(tabName: 'Bills', tabController: _tabController),
                    TabView(tabName: 'Others', tabController: _tabController),
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
