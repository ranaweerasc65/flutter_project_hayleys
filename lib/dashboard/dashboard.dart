import 'package:flutter/material.dart';
import '../config.dart';
import '../illness_page.dart';
import '../bills_page.dart';
import '../prescriptions_page.dart';
import '../reports_page.dart';
import '../insurance_card.dart';
import '../settings.dart';
import '../profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../bottom_navigation.dart';

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
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<Dashboard> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    print('DASHBOARD SCREEN');

    // Print the customerId here
    print('Customer ID: ${widget.customerId}');
    print(widget.phoneNo);

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Insurance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14.0, // Font size for selected labels
        unselectedFontSize: 12.0, // Font size for unselected labels
        iconSize: 30.0,
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

class _DashboardContentState extends State<DashboardContent> {
  String firstName = '';
  String lastName = '';

  @override
  void initState() {
    super.initState();
    // Call the fetch method to retrieve customer details
    _fetchCustomerDetails();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row: Profile Image and Notification Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile Image
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                          'assets/user.png'), // Replace with your user image path
                    ),

                    // Notification Button
                    IconButton(
                      icon:
                          const Icon(Icons.notifications, color: Colors.black),
                      onPressed: () => _showNotifications(context),
                      iconSize: 40.0,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Services Section
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Custom Cards
                _buildCustomCard(
                  context,
                  'Illness',
                  'View your illness details',
                  'assets/sick.png',
                  IllnessPage(),
                ),
                const SizedBox(height: 16),
                _buildCustomCard(
                  context,
                  'Bills',
                  'Manage and pay your bills',
                  'assets/bills.png',
                  const BillsPage(),
                ),
                const SizedBox(height: 16),
                _buildCustomCard(
                  context,
                  'Prescriptions',
                  'Check your prescriptions',
                  'assets/prescriptions.png',
                  const PrescriptionsPage(),
                ),
                const SizedBox(height: 16),
                _buildCustomCard(
                  context,
                  'Reports',
                  'Access your medical reports',
                  'assets/reports.png',
                  const ReportsPage(),
                ),
              ],
            ),
          ),
        ));
  }
}

Widget _buildCustomCard(
  BuildContext context,
  String title,
  String subtitle,
  String assetPath,
  Widget navigateTo,
) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navigateTo),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            assetPath,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void _showNotifications(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Notifications'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.notification_important, color: Colors.orange),
              title: Text('New message from Dr. Smith'),
            ),
            ListTile(
              leading: Icon(Icons.notification_important, color: Colors.orange),
              title: Text('Your report is ready'),
            ),
            ListTile(
              leading: Icon(Icons.notification_important, color: Colors.orange),
              title: Text('Prescription updated'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
