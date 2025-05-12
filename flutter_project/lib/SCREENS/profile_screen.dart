// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profilo')),
      body: Center(child: Text('Profilo utente')), // Avatar, info, modifica, ecc.
    );
  }
}
