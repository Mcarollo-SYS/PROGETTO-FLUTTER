// lib/screens/add_screen.dart
import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aggiungi Transazione')),
      body: Center(child: Text('Form Aggiunta')), // Sarà il form per entrate/uscite
    );
  }
}