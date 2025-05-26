import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Transazione {
  final int id;
  final String descrizione;
  final double importo;
  final String tipo; // 'entrata' o 'uscita'
  final String data;

  Transazione({
    required this.id,
    required this.descrizione,
    required this.importo,
    required this.tipo,
    required this.data,
  });

  factory Transazione.fromJson(Map<String, dynamic> json) {
    return Transazione(
      id: json['id'],
      descrizione: json['descrizione'] ?? '',
      importo: double.parse(json['importo'].toString()),
      tipo: json['tipo'],
      data: json['data'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double entrate = 0;
  double uscite = 0;
  List<Transazione> transazioni = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    const String apiUrl = 'https://tuo-sito.it/api/home_data.php?utente_id=1';
    // Per test locale puoi usare un JSON statico o un mock server

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          entrate = double.parse(data['tot_entrate'].toString());
          uscite = double.parse(data['tot_uscite'].toString());
          transazioni = (data['transazioni'] as List)
              .map((json) => Transazione.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Errore nel caricamento dati dal server';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Errore di connessione: $e';
        isLoading = false;
      });
    }
  }

  Widget _buildEntrateUsciteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Entrate
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Entrate',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '€ ${entrate.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          // Uscite
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Uscite',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '€ ${uscite.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransazioneTile(Transazione t) {
    final isEntrata = t.tipo == 'entrata';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isEntrata ? Colors.green : Colors.redAccent,
        child: Icon(isEntrata ? Icons.arrow_downward : Icons.arrow_upward,
            color: Colors.white),
      ),
      title: Text(t.descrizione),
      subtitle: Text(t.data),
      trailing: Text(
        (isEntrata ? '+' : '-') + '€ ${t.importo.toStringAsFixed(2)}',
        style: TextStyle(
            color: isEntrata ? Colors.green : Colors.redAccent,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text(errorMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteSpese'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.black87,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            _buildEntrateUsciteCard(),
            Expanded(
              child: transazioni.isEmpty
                  ? const Center(child: Text('Nessuna transazione trovata'))
                  : ListView.builder(
                      itemCount: transazioni.length,
                      itemBuilder: (context, index) {
                        return _buildTransazioneTile(transazioni[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}