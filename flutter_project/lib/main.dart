import 'package:flutter/material.dart';
import 'SCREENS/login_screen.dart';
import 'SCREENS/main_navigation_screen.dart';

void main() => runApp(const NoteSpeseApp());

class NoteSpeseApp extends StatelessWidget {
  const NoteSpeseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoteSpese',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainNavigationScreen(),
      },
    );
  }
}