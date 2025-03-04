import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/approvals.dart';
import 'package:flutter_project_hayleys/dashboard/dashboard.dart';
import 'login_screen.dart';
import 'primary_user_details.dart';
import 'user_details.dart';
import 'package:http/http.dart' as http;
import 'edit_user_details.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'config.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String phoneNo;

  const HomeScreen({super.key, required this.userName, required this.phoneNo});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? customerId;
  bool _isLoading = false;

  //final List<String> MyConnections = [];

  //List<String> Connections = [];
  List<Map<String, dynamic>> connections = [];

  @override
  void initState() {
    super.initState();

    print('home_page.dart');

    // Print phone number to the terminal
    print(
        'Logged in user phone number (home_page.dart): ${widget.phoneNo}'); // This will print the phone number

    // Print the username to the terminal
    print('Logged in user Username (home_page.dart): ${widget.userName}');
    fetchConnections();
  }

  // Refresh function for pull-to-refresh
  Future<void> _refreshData() async {
    await fetchConnections(); // Re-fetch connections
    await fetchEmployeeId(); // Optionally re-fetch employee ID if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/user.png'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.phoneNo,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard, color: Colors.blue),
                    title: const Text('Dashboard'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ApprovalsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.green),
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ApprovalsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt, color: Colors.orange),
                    title: const Text('Bills & Payments'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ApprovalsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.purple),
                    title: const Text('Claim History'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ApprovalsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help, color: Colors.red),
                    title: const Text('Support'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ApprovalsPage()),
                      );
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
            // Logout button at the bottom
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.05,
              image: AssetImage("assets/background_pattern.jpg"),
              repeat: ImageRepeat.repeat,
            ),
          ),
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade900,
                    Colors.blue.shade800,
                    Colors.blue.shade400,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.notifications,
                            color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Notifications"),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.medical_services,
                                          color: Colors.blue),
                                      title: Text(
                                          "Your latest medical bill has been updated."),
                                    ),
                                    Divider(),
                                    ListTile(
                                      leading: Icon(Icons.attach_money,
                                          color: Colors.green),
                                      title: Text(
                                          "Insurance claim processed successfully."),
                                    ),
                                    Divider(),
                                    ListTile(
                                      leading: Icon(Icons.warning,
                                          color: Colors.red),
                                      title: Text("Pending payment due soon!"),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Close"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),

                      // // Logout Button
                      // IconButton(
                      //   icon: const Icon(Icons.logout, color: Colors.white),
                      //   onPressed: () => _showLogoutConfirmationDialog(context),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Added to space items
                      children: [
                        // Text Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome!",
                              style: TextStyle(
                                color: Color.fromARGB(255, 196, 222, 241),
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.userName,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 223, 234, 242),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "How is it going today?",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 234, 232, 232),
                              ),
                            ),
                          ],
                        ),
                        // Image Section
                        Image.asset(
                          'assets/quick_access.webp',
                          width: 150, // Adjust size as needed
                          height: 150, // Adjust size as needed
                          fit: BoxFit.cover, // Adjust how the image fits
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData, // Callback for pull-to-refresh
                color: Colors.blue.shade900, // Refresh indicator color
                backgroundColor: Colors.white, // Background of the indicator
                child: _isLoading
                    ? Center(
                        child: LoadingAnimationWidget.halfTriangleDot(
                          color: const Color.fromARGB(255, 5, 101, 185),
                          size: 30,
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Primary User Section
                              Center(
                                child: _buildPrimaryUserCard(),
                              ),
                              const SizedBox(height: 20),

                              // My Connections Section
                              _buildSectionTitle("My Connections"),
                              const SizedBox(height: 20),
                              _buildConnectionsList(),
                            ],
                          ),
                        ),
                      ),
              ),
            )
          ],
        ),
      ]),
    );
  }

  Widget _buildPrimaryUserCard() {
    return GestureDetector(
      onTap: () async {
        await fetchEmployeeId();
        print('Fetched Employee Id: $customerId');
        if (customerId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(
                phoneNo: widget.phoneNo,
                userName: widget.userName,
                customerId: customerId!,
              ),
            ),
          );
        } else {
          showError('Please enter the primary user details first');
        }
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade100, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                minWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/user.png',
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.1,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  Container(
                    width: 1,
                    height: MediaQuery.of(context).size.height * 0.15,
                    color: Colors.blue.shade300,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      //Text(
                      //'${connection['CUSTOMERS_FIRST_NAME']} ${connection['CUSTOMERS_LAST_NAME']}',
                      children: [
                        Text(
                          widget.userName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005),
                        Text(
                          "ID: ${customerId ?? 'N/A'}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        Text(
                          "Quick Access",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildQuickAccessButton(
                              label: "Dashboard",
                              color: Colors.blue.shade800,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Dashboard(
                                      phoneNo: widget.phoneNo,
                                      userName: widget.userName,
                                      customerId: customerId!,
                                    ),
                                  ),
                                );
                              },
                            ),
                            _buildQuickAccessButton(
                              label: "Insurance Cards",
                              color: Colors.blue.shade800,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ApprovalsPage()), // Replace with Insurance page
                                );
                              },
                            ),
                            _buildQuickAccessButton(
                              label: "Claims",
                              color: Colors.blue.shade800,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ApprovalsPage()), // Replace with Claims page
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Edit Button
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrimaryUserDetails(
                        phoneNo: widget.phoneNo,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 25,
                    color: Color.fromARGB(255, 243, 33, 89),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Enhanced Quick Access Button
  Widget _buildQuickAccessButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.008,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.5), width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.015,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildConnectionsList() {
    return SizedBox(
      height: 159,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...connections.map((connection) => _buildConnectionCard(connection)),
          _buildAddConnectionCard(),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(Map<String, dynamic> connection) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: () {
          print(
              '${connection['CUSTOMERS_FIRST_NAME']} ${connection['CUSTOMERS_LAST_NAME']}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(
                phoneNo: widget.phoneNo,
                userName: widget.userName,
                customerId: connection['CUSTOMERS_ID'],
              ),
            ),
          );
        },
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Container(
                width: 130,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 126, 191, 245),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/user.png',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${connection['CUSTOMERS_FIRST_NAME']} ${connection['CUSTOMERS_LAST_NAME']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'ID: ${connection['CUSTOMERS_ID']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUserDetails(
                          phoneNo: widget.phoneNo,
                          userName: widget.userName,
                          customerId: connection['CUSTOMERS_ID'],
                        ),
                      ),
                    ).then((updatedConnection) {
                      if (updatedConnection != null) {
                        setState(() {
                          connection['CUSTOMERS_FIRST_NAME'] =
                              updatedConnection["first_name"];
                          connection['CUSTOMERS_LAST_NAME'] =
                              updatedConnection["last_name"];
                        });
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddConnectionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: () async {
          final updatedConnections = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetails(
                phoneNo: widget.phoneNo,
                userName: widget.userName,
              ),
            ),
          );
          if (updatedConnections != null) {
            setState(() {
              // Update logic here if needed, e.g., fetchConnections()
            });
          }
        },
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(31, 225, 133, 20),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  size: 50,
                  color: Colors.orange,
                ),
                SizedBox(height: 10),
                Text(
                  "Add New",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Logout Confirmation",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(context); // Call the logout function
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

// Logout Function
  Future<void> _logout(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void addConnection(List<String> connectionList) {
    setState(() {
      connectionList.add(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/800px-User_icon_2.svg.png',
      );
    });
  }

  Future<void> fetchConnections() async {
    setState(() {
      _isLoading = true;
    });

    print("fetchConnections");
    final url = Uri.parse(
        "${Config.baseUrl}get_connections.php?phone_no=${widget.phoneNo}");

//172.16.200.79
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("status = 200");
        print('Response body: ${response.body}');

        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          print("status = success");
          setState(() {
            connections = List<Map<String, dynamic>>.from(data['connections']);
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching connections: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchEmployeeId() async {
    final url = Uri.parse(
        "${Config.baseUrl}fetch_primary_user_details.php?phone_no=${widget.phoneNo}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            customerId = responseData['existing_data']['CUSTOMERS_ID'];
          });
        } else {
          showError(responseData['message']);
        }
      } else {
        showError('Failed to fetch customer data');
      }
    } catch (e) {
      showError('Error occurred: $e');
    }
  }

  Future<void> fetchCustomerId() async {
    final url = Uri.parse(
        "${Config.baseUrl}fetch_user_details.php?phone_no=${widget.phoneNo}");

//172.16.200.79
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            customerId = responseData['existing_data']['CUSTOMERS_ID'];
          });
        } else {
          showError(responseData['message']);
        }
      } else {
        showError('Failed to fetch customer data');
      }
    } catch (e) {
      showError('Error occurred: $e');
    }
  }

  void showError(String message) {
    // Print the error message to the terminal
    print('Error: $message');

    // Display the error message in a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour >= 0 && hour < 12) {
    return 'Good Morning';
  } else if (hour >= 12 && hour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}



////// home page worked 
