import 'package:flutter/material.dart';
import 'package:flutter_project/SCREENS/home_screen.dart';
import 'package:flutter_project/SCREENS/main_navigation_screen.dart';
import 'package:flutter_project/SCREENS/stats_screen.dart';
import 'package:flutter_project/SCREENS/add_screen.dart';
import 'package:flutter_project/SCREENS/profile_screen.dart';

void main() => runApp(NoteSpeseApp());

class NoteSpeseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoteSpese',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: MainNavigationScreen(),
    );
  }
}