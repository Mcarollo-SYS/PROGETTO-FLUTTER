// lib/SCREENS/add_screen.dart
import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aggiungi Transazione')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrizione'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Importo'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField(
                items: [
                  DropdownMenuItem(child: Text('Entrata'), value: 'entrata'),
                  DropdownMenuItem(child: Text('Uscita'), value: 'uscita'),
                ],
                onChanged: (val) {},
                decoration: InputDecoration(labelText: 'Tipo'),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Salva'),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}