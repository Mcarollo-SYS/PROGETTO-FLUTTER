import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool _loading = true;
  String total = "€ 0,00";
  String average = "€ 0,00";
  String count = "0";
  String? _error;

  Future<void> fetchStats() async {
    // Passo 1: Ottieni user_id
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    // Passo 2: Verifica autenticazione
    if (userId == null) {
      setState(() {
        _error = "Errore: Utente non autenticato.";
        _loading = false;
      });
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    // Passo 3: Chiamata API con user_id
    try {
      final response = await http.get(
        Uri.parse("http://localhost/API/stats.php?user_id=$userId"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            total = "€ ${data['total']}";
            average = "€ ${data['average']}";
            count = data['transactions'].toString();
            _loading = false;
          });
        } else {
          setState(() {
            _error = data['message'] ?? 'Errore sconosciuto';
            _loading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Errore HTTP: ${response.statusCode}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Errore di rete: $e';
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Statistiche')),
        body: Center(child: Text('Errore: $_error')),
      );
    }

    // ... (il resto del metodo build rimane invariato)
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Statistiche'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Spese mensili',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: const Center(
                      child: Text('Grafico in arrivo 📊'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _statTile(title: 'Spesa Totale', value: total),
                  const SizedBox(height: 12),
                  _statTile(title: 'Media Mensile', value: average),
                  const SizedBox(height: 12),
                  _statTile(title: 'Numero Transazioni', value: count),
                  const Spacer(),
                  const Center(
                    child: Text('Più dati arriveranno presto!'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _statTile({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}