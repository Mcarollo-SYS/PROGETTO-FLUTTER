// lib/main.dart
import 'package:flutter/material.dart';
import 'SCREENS/main_navigation_screen.dart';

void main() => runApp(NoteSpeseApp());

class NoteSpeseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoteSpese',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: MainNavigationScreen(),
    );
  }
}