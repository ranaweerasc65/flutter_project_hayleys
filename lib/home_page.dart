import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/approvals.dart';
import 'package:flutter_project_hayleys/dashboard.dart';
import 'login_screen.dart';
import 'primary_user_details.dart';
import 'user_details.dart';
import 'package:http/http.dart' as http;
import 'edit_user_details.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String phoneNo;

  const HomeScreen({super.key, required this.userName, required this.phoneNo});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? customerId;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            builder: (context) => ApprovalsPage()),
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
                            builder: (context) => ApprovalsPage()),
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
                            builder: (context) => ApprovalsPage()),
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
                            builder: (context) => ApprovalsPage()),
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
      body: Column(
        children: [
          // Gradient Header
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
                    // Notification Button
                    IconButton(
                      icon:
                          const Icon(Icons.notifications, color: Colors.white),
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
                                    leading:
                                        Icon(Icons.warning, color: Colors.red),
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

                    // Logout Button
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () => _showLogoutConfirmationDialog(context),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Profile Image - Circular
                      ClipOval(
                        child: Image.asset(
                          'assets/user.png',
                          fit: BoxFit.cover,
                          width: 80, // Adjust size as needed
                          height: 80,
                        ),
                      ),
                      const SizedBox(
                          width: 15), // Spacing between image and text

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
                            "Hello, ${widget.userName}",
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
                    ],
                  ),
                )
              ],
            ),
          ),

          // Main Content (Employee details & connections)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Employee Details Section
                  Center(
                    child: GestureDetector(
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
                          showError('Employee ID is null');
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(27, 86, 225, 0.298),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  margin: const EdgeInsets.only(top: 16),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/user.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
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
                                  size: 20,
                                  color: Color.fromARGB(255, 243, 33, 89),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: const Text(
                      "My Connections",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...connections.map((connection) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Stack(
                              children: [
                                // Main Container
                                Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromRGBO(27, 86, 225, 0.298),
                                        blurRadius: 20,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          print(
                                              '${connection['CUSTOMERS_FIRST_NAME']} ${connection['CUSTOMERS_LAST_NAME']}');
                                          // Navigate to the Dashboard page
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Dashboard(
                                                phoneNo: widget.phoneNo,
                                                userName: widget.userName,
                                                customerId:
                                                    connection['CUSTOMERS_ID'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          child: ClipOval(
                                            child: Image.asset(
                                              'assets/user.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Column(
                                        children: [
                                          Text(
                                            '${connection['CUSTOMERS_FIRST_NAME']} ${connection['CUSTOMERS_LAST_NAME']}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'ID: ${connection['CUSTOMERS_ID']}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(
                                                  255, 102, 99, 99),
                                            ),
                                          ),
                                        ],
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
                                      // Navigate to the EditUserDetails screen and pass the customer details
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditUserDetails(
                                            phoneNo: widget.phoneNo,
                                            userName: widget.userName,
                                            customerId:
                                                connection['CUSTOMERS_ID'],
                                          ),
                                        ),
                                      ).then((updatedConnection) {
                                        // Handle the updated connection data
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
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Color.fromARGB(255, 243, 33, 89),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        // Add New Connection Button
                        GestureDetector(
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
                              // Update the Connections list with the new data
                              setState(() {
                                // Connections = updatedConnections;
                              });
                            }
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(27, 86, 225, 0.298),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 50,
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    print("fetchConnections");
    final url = Uri.parse(
        'http://172.16.200.79/flutter_project_hayleys/php/get_connections.php?phone_no=${widget.phoneNo}');

    //192.168.62.145
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
    }
  }

  Future<void> fetchEmployeeId() async {
    final url = Uri.parse(
        'http://172.16.200.79/flutter_project_hayleys/php/fetch_primary_user_details.php?phone_no=${widget.phoneNo}');

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
        'http://172.16.200.79/flutter_project_hayleys/php/fetch_user_details.php?phone_no=${widget.phoneNo}');

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
