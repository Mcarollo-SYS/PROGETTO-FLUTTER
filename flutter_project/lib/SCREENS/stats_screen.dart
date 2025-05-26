import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Schermata Statistiche, mostra dati spesa totale, media mensile e numero transazioni
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool _loading = true;   // Stato caricamento dati
  String total = "€ 0,00";    // Spesa totale iniziale (default)
  String average = "€ 0,00";  // Media mensile iniziale (default)
  String count = "0";          // Numero transazioni iniziale (default)
  String? _error;              // Messaggio di errore (se presente)

  // Metodo che richiama il backend per ottenere le statistiche
  Future<void> fetchStats() async {
    // Passo 1: Recupera l'user_id salvato in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    // Passo 2: Se user_id non è presente, l'utente non è autenticato
    if (userId == null) {
      setState(() {
        _error = "Errore: Utente non autenticato.";
        _loading = false;
      });
      // Reindirizza alla schermata login rimuovendo tutta la cronologia
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    // Passo 3: Effettua la chiamata HTTP per ottenere i dati dal backend PHP
    try {
      final response = await http.get(
        Uri.parse("http://localhost/API/stats.php?user_id=$userId"),
      );

      // Se la risposta è OK (codice 200)
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Se il backend segnala successo (success = true)
        if (data['success'] == true) {
          setState(() {
            // Aggiorna i valori delle statistiche con quelli ricevuti
            total = "€ ${data['total']}";
            average = "€ ${data['average']}";
            count = data['transactions'].toString();
            _loading = false; // Dati caricati, disabilita loading
          });
        } else {
          // Se success false, mostra messaggio di errore specifico
          setState(() {
            _error = data['message'] ?? 'Errore sconosciuto';
            _loading = false;
          });
        }
      } else {
        // Se codice HTTP non è 200, mostra errore HTTP
        setState(() {
          _error = 'Errore HTTP: ${response.statusCode}';
          _loading = false;
        });
      }
    } catch (e) {
      // Gestione errori di rete o di parsing JSON
      setState(() {
        _error = 'Errore di rete: $e';
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStats(); // Avvia il caricamento dati all'inizializzazione dello stato
  }

  @override
  Widget build(BuildContext context) {
    // Se c'è un errore, mostra una schermata con il messaggio
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Statistiche')),
        body: Center(child: Text('Errore: $_error')),
      );
    }

    // Struttura principale della schermata Statistiche
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Statistiche'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      // Se è in caricamento mostra un indicatore circolare
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Titolo sezione grafico
                  const Text(
                    'Spese mensili',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Box dove andrà il grafico futuro
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

                  // Tiles per mostrare i dati statistici
                  _statTile(title: 'Spesa Totale', value: total),
                  const SizedBox(height: 12),
                  _statTile(title: 'Media Mensile', value: average),
                  const SizedBox(height: 12),
                  _statTile(title: 'Numero Transazioni', value: count),
                  const Spacer(),

                  // Nota informativa per future funzionalità
                  const Center(
                    child: Text('Più dati arriveranno presto!'),
                  ),
                ],
              ),
            ),
    );
  }

  // Widget personalizzato per una riga di statistica con titolo e valore
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