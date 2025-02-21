import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Subtle shadow
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, -4), // Soft shadow effect
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: onTap,
          elevation: 0, // Remove default elevation
          backgroundColor: Colors.white, // Clean background
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 28),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 28),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety, size: 28),
              label: 'Insurance',
            ),
          ],
          selectedItemColor: Colors.blue.shade900, // Elegant blue shade
          unselectedItemColor:
              Colors.grey.shade500, // Softer grey for better contrast
          selectedFontSize: 15.0,
          unselectedFontSize: 13.0,
          iconSize: 30.0,
        ),
      ),
    );
  }
}
