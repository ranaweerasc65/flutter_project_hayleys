import 'package:flutter/material.dart';
import 'package:flutter_project_hayleys/dashboard.dart';
import 'login_screen.dart';
import 'profile.dart';
import 'approvals.dart';
import 'primary_user_details.dart';
import 'user_details.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String phoneNo;

  const HomeScreen({super.key, required this.userName, required this.phoneNo});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomeContent(userName: widget.userName, phoneNo: widget.phoneNo),
      const ProfilePage(),
      const ApprovalsPage(),
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

  Future<void> _logout(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          TextButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout, color: Colors.black),
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.approval),
            label: 'Approvals',
          ),
        ],
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final String userName;
  final String phoneNo; // Add this line to accept the phone number

  const HomeContent({super.key, required this.userName, required this.phoneNo});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final List<String> MyConnections = [];

  List<String> Connections = [];

  @override
  void initState() {
    super.initState();

    print('home_page.dart');

    // Print phone number to the terminal
    print(
        'Logged in user phone number (home_page.dart): ${widget.phoneNo}'); // This will print the phone number

    // Print the username to the terminal
    print('Logged in user Username (home_page.dart): ${widget.userName}');
  }

  void addConnection(List<String> connectionList) {
    setState(() {
      connectionList.add(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/800px-User_icon_2.svg.png',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
            child: Container(
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
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome!",
                          style: TextStyle(
                            color: Color.fromARGB(255, 196, 222, 241),
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            '${getGreeting()}, ${widget.userName}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 223, 234, 242),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "How is it going today?",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 199, 195, 195),
                          ),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/800px-User_icon_2.svg.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // FLOW TREE CONNECTION UI SETUP - 17/12/2024

          const SizedBox(height: 10),

          // Employee details

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Dashboard(),
                  ),
                );
              },
              child: Stack(
                children: [
                  // Main Container
                  Container(
                    width: 120, // Adjust the width as needed
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
                        // Profile Picture
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 16),
                          child: ClipOval(
                            child: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/800px-User_icon_2.svg.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  // Edit Button Positioned at the Top-Right
                  Positioned(
                    top: 5, // Adjust as needed
                    right: 5, // Adjust as needed
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to UserDetails form to edit the connection
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

          // connections

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
            height: 127,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...List.generate(
                  Connections.length,
                  (index) => Padding(
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
                                color: Color.fromRGBO(27, 86, 225, 0.298),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Profile Picture
                              Container(
                                height: 100,
                                width: 100,
                                margin: const EdgeInsets.only(top: 16),
                                child: ClipOval(
                                  child: Image.network(
                                    Connections[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        // Edit Button Positioned at the Top-Right of each connection
                        Positioned(
                          top: 5, // Adjust as needed
                          right: 5, // Adjust as needed
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to the UserDetails form to edit the connection
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetails(
                                    phoneNo: widget.phoneNo,
                                    userName: widget.userName,
                                    connections: Connections,
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

                // Plus Button to Add New Connection
                GestureDetector(
                  onTap: () async {
                    final updatedConnections = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetails(
                          phoneNo: widget.phoneNo,
                          userName: widget.userName,
                          connections: Connections, // Pass the current list
                        ),
                      ),
                    );

                    if (updatedConnections != null) {
                      // Update the Connections list with the new data
                      setState(() {
                        Connections = updatedConnections;
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
          )
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
