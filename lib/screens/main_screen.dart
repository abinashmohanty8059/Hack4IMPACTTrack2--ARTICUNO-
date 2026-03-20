import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'home_screen.dart';
import 'chatbot_screen.dart';
import 'alerts_screen.dart';
import 'doctor_screen.dart';
import 'analytics_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ChatBotScreen(),
    AlertsScreen(),
    DoctorScreen(),
    AnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.tealAccent.withOpacity(0.4),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: GNav(
              gap: 8,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.teal,
              padding: const EdgeInsets.all(12),
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: const [
                GButton(icon: Icons.home, text: "Home"),
                GButton(icon: Icons.chat_bubble, text: "Chat Bot"),
                GButton(icon: Icons.travel_explore, text: "Alerts"),
                GButton(icon: Icons.local_hospital, text: "Doctors"),
                GButton(icon: Icons.more_horiz, text: "Analytics"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
