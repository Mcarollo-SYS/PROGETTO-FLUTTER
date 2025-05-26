import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../MODEL/statistiche.dart'; // Assicurati che il path sia corretto

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Statistiche? _statistiche;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStatistiche();
  }

  Future<void> fetchStatistiche() async {
    const url = 'http://tuo-dominio.com/php/get_statistiche.php?utente_id=1'; // Modifica URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _statistiche = Statistiche.fromJson(data);
          _isLoading = false;
        });
      } else {
        throw Exception('Errore nel caricamento');
      }
    } catch (e) {
      print('Errore: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Statistiche',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _statistiche == null
              ? const Center(child: Text('Nessun dato disponibile'))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Spese mensili',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
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
                          child: Text(
                            'Grafico in arrivo 📊',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _statTile(title: 'Spesa Totale', value: '€ ${_statistiche!.spesaTotale.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _statTile(title: 'Media Mensile', value: '€ ${_statistiche!.mediaMensile.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _statTile(title: 'Numero Transazioni', value: '${_statistiche!.numeroTransazioni}'),
                      const Spacer(),
                      const Center(
                        child: Text(
                          'Più dati arriveranno presto!',
                          style: TextStyle(fontSize: 14, color: Colors.black38),
                        ),
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
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.black87)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}