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
  String _totalExpenses = "€ 0,00";    // Spesa totale (uscite)
  String _averageExpenses = "€ 0,00";  // Media delle spese (uscite)
  String _numberOfExpenseTransactions = "0"; // Numero di transazioni di spesa (uscite)
  String? _error;              // Messaggio di errore (se presente)

  // Metodo che richiama il backend per ottenere le statistiche
  Future<void> fetchStats() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final prefs = await SharedPreferences.getInstance();
    // Assicurati che la chiave sia 'user_id' come salvata durante il login
    final userId = prefs.getInt('user_id');

    if (!mounted) return; // Verifica se il widget è ancora montato

    if (userId == null) {
      setState(() {
        _error = "Errore: Utente non autenticato.";
        _loading = false;
      });
      // Reindirizza alla schermata login rimuovendo tutta la cronologia
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    // SOSTITUISCI CON IL TUO IP E PERCORSO CORRETTO
    // Esempio per emulatore Android: "http://10.0.2.2/PROGETTO-FLUTTER/flutter_project/lib/API/stats.php?user_id=$userId"
    // Esempio per iOS e dispositivo fisico (usa l'IP della tua macchina sulla rete locale):
    // "http://192.168.1.XXX/PROGETTO-FLUTTER/flutter_project/lib/API/stats.php?user_id=$userId"
    final String apiUrl = "http://10.0.2.2/PROGETTO-FLUTTER/flutter_project/lib/API/stats.php?user_id=$userId";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          setState(() {
            // I nomi dei campi 'total', 'average', 'transactions' devono corrispondere
            // a quelli restituiti dallo script PHP corretto.
            _totalExpenses = "€ ${data['total'] ?? '0,00'}";
            _averageExpenses = "€ ${data['average'] ?? '0,00'}";
            _numberOfExpenseTransactions = (data['transactions'] ?? 0).toString();
            _loading = false;
          });
        } else {
          setState(() {
            _error = data['message'] ?? 'Errore sconosciuto dal server';
            _loading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Errore HTTP: ${response.statusCode}\nResponse: ${response.body}';
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Errore di rete: $e.\nAssicurati che il server sia in esecuzione e l\'URL ($apiUrl) sia corretto.';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Statistiche Spese'), // Titolo più specifico
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [ // Aggiunto un pulsante di refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchStats, // Richiama fetchStats per aggiornare
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Errore: $_error', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchStats,
                child: const Text('Riprova'),
              )
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Riepilogo Spese Mensili', // Titolo più descrittivo
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
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
              child: Text('Grafico in arrivo 📊', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 30),
          _statTile(title: 'Spesa Totale (Uscite)', value: _totalExpenses),
          const SizedBox(height: 12),
          _statTile(title: 'Media Spese (Uscite)', value: _averageExpenses),
          const SizedBox(height: 12),
          _statTile(title: 'Numero Spese Effettuate', value: _numberOfExpenseTransactions),
          const Spacer(),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Ulteriori statistiche e filtri saranno disponibili a breve!',
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded( // Per gestire testi lunghi
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            )
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.deepPurple), // Colore diverso per il valore
          ),
        ],
      ),
    );
  }
}