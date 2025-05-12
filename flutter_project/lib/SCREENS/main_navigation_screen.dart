// lib/SCREENS/main_navigation_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'stats_screen.dart';
import 'add_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    StatsScreen(),
    AddScreen(),
    ProfileScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.bar_chart,
    Icons.add_circle,
    Icons.person,
  ];

  final List<String> _labels = [
    'Home',
    'Statistiche',
    'Aggiungi',
    'Profilo'
  ];

@override
Widget build(BuildContext context) {
  return Scaffold(
    extendBody: true, // Per far “galleggiare” la navigation bar
    body: _screens[_currentIndex],
    bottomNavigationBar: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: List.generate(
            _icons.length,
            (i) => NavigationDestination(
              icon: Icon(_icons[i]),
              label: _labels[i],
            ),
          ),
        ),
      ),
    ),
  );
}
}