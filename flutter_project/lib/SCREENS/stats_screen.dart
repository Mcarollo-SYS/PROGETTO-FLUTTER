import 'package:flutter/material.dart';
import 'package:flutter_project/statistiche_api.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  double _totaleUscite = 0.0;
  double _mediaMensile = 0.0;
  int _numeroTransazioni = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final api = StatisticheApi();
    try {
      final totaleUscite = await api.getTotaleUscite();
      final mediaMensile = await api.getMediaMensile();
      final numeroTransazioni = await api.getNumeroTransazioni();
      setState(() {
        _totaleUscite = totaleUscite;
        _mediaMensile = mediaMensile;
        _numeroTransazioni = numeroTransazioni;
      });
    } catch (e) {
      print('Errore nel recupero delle statistiche: $e');
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
      body: Padding(
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
            _statTile(
              title: 'Spesa Totale',
              value: '€ ${_totaleUscite.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 12),
            _statTile(
              title: 'Media Mensile',
              value: '€ ${_mediaMensile.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 12),
            _statTile(
              title: 'Numero Transazioni',
              value: '$_numeroTransazioni',
            ),
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
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
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
