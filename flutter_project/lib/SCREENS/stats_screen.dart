// lib/SCREENS/stats_screen.dart
import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistiche')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 80, color: Colors.teal),
            SizedBox(height: 10),
            Text('Statistiche non ancora disponibili', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}