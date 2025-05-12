// lib/SCREENS/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profilo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/avatar.png')),
            SizedBox(height: 10),
            Text('Jacob Timberli', style: TextStyle(fontSize: 18)),
            Text('jacob@email.com', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text('Modifica profilo')),
          ],
        ),
      ),
    );
  }
}