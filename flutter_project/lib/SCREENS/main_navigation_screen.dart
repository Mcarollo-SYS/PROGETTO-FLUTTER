import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'stats_screen.dart';
import 'add_screen.dart';
import 'profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int? _userId;
  int _currentIndex = 0;
  late List<Widget> _screens;

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
    'Profilo',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('userId');

    if (id == null) {
      // Puoi mostrare una schermata di login o impostare un ID di default
      id = 1;
    }

    setState(() {
      _userId = id;
      _screens = [
        const HomeScreen(),
        const StatsScreen(),
        const AddScreen(),
        ProfileScreen(userId: _userId!), // userId dinamico
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(22, 39, 16, 209),
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
            onDestinationSelected: (index) =>
                setState(() => _currentIndex = index),
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