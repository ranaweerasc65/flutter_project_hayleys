import 'package:flutter/material.dart';
import 'illness_page.dart';
import 'bills_page.dart';
import 'prescriptions_page.dart';
import 'reports_page.dart';
import 'others_page.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'First Name + Last Name',
          style: TextStyle(
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
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
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
                    icon: const Icon(Icons.notifications, color: Colors.black),
                    onPressed: () => _showNotifications(context),
                    iconSize: 40.0,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar and Filter Icon
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 232, 233, 235),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 20),

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
                BillsPage(),
              ),
              const SizedBox(height: 16),
              _buildCustomCard(
                context,
                'Prescriptions',
                'Check your prescriptions',
                'assets/prescriptions.png',
                PrescriptionsPage(),
              ),
              const SizedBox(height: 16),
              _buildCustomCard(
                context,
                'Reports',
                'Access your medical reports',
                'assets/reports.png',
                ReportsPage(),
              ),
            ],
          ),
        ),
      ),
    );
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
                leading:
                    Icon(Icons.notification_important, color: Colors.orange),
                title: Text('New message from Dr. Smith'),
              ),
              ListTile(
                leading:
                    Icon(Icons.notification_important, color: Colors.orange),
                title: Text('Your report is ready'),
              ),
              ListTile(
                leading:
                    Icon(Icons.notification_important, color: Colors.orange),
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
}
