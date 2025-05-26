import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Schermata principale che mostra entrate, uscite e riepiloghi spese
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double entrate = 0.0;    // Variabile per memorizzare il totale entrate
  double uscite = 0.0;     // Variabile per memorizzare il totale uscite
  bool isLoading = true;   // Flag per indicare se i dati sono in caricamento

  @override
  void initState() {
    super.initState();
    fetchTotali();  // Al caricamento della pagina, carica i totali da backend
  }

  // Funzione asincrona che recupera i totali entrate e uscite dal backend PHP
  Future<void> fetchTotali() async {
    try {
      // Ottiene l'istanza di SharedPreferences per accedere ai dati salvati
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId'); // Recupera l'ID utente salvato

      if (userId == null) {
        // Se non esiste userId, mostra un messaggio di errore e ritorna
        print("User ID non trovato!");
        return;
      }

      // Effettua una richiesta GET all'API per ottenere i totali per l'utente
      final response = await http.get(
        Uri.parse('http://localhost/htdocs/API/getTotals.php?utente_id=$userId')
      );

      if (response.statusCode == 200) {
        // Se la risposta è OK, decodifica i dati JSON ricevuti
        final data = json.decode(response.body);
        setState(() {
          // Aggiorna lo stato con i valori ottenuti, convertiti in double
          entrate = double.tryParse(data['entrate'].toString()) ?? 0.0;
          uscite = double.tryParse(data['uscite'].toString()) ?? 0.0;
          isLoading = false;  // Termina il caricamento
        });
      } else {
        // Se la risposta non è 200, stampa un errore con il body ricevuto
        print("Errore nella risposta: ${response.body}");
      }
    } catch (e) {
      // In caso di errori di connessione o altro, stampa l'errore
      print("Errore nella connessione: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Sfondo bianco
      appBar: AppBar(
        backgroundColor: Colors.white,  // AppBar bianca
        elevation: 0.5,                  // Ombra leggera sotto la AppBar
        centerTitle: true,
        title: const Text(
          'NoteSpese',                  // Titolo dell'app
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),  // Colore icone AppBar
      ),
      body: isLoading
          // Se i dati sono in caricamento mostra spinner al centro
          ? const Center(child: CircularProgressIndicator())
          // Altrimenti mostra i dati
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contenitore per visualizzare entrate e uscite
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),            // Sfondo chiaro
                      borderRadius: BorderRadius.circular(16),   // Angoli arrotondati
                      border: Border.all(color: const Color(0xFFE0E0E0)), // Bordo sottile
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Colonna per le Entrate
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Entrate',                      // Label
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,          // Verde per entrate
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '€ ${entrate.toStringAsFixed(2)}',  // Importo formattato a 2 decimali
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        // Colonna per le Uscite
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Uscite',                       // Label
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.redAccent,     // Rosso per uscite
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '€ ${uscite.toStringAsFixed(2)}',   // Importo formattato
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
                  ),
                  const Text(
                    'Benvenuto 👋',   // Testo di benvenuto
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Controlla e gestisci le tue spese facilmente.', // Sottotitolo
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Card con info sul totale spese (entrate - uscite)
                  _infoCard(title: 'Totale Spese', value: '€ ${(entrate - uscite).toStringAsFixed(2)}'),
                  const SizedBox(height: 16),
                  // Card con info sulle spese del mese (qui uscite)
                  _infoCard(title: 'Spese Mese', value: '€ ${uscite.toStringAsFixed(2)}'),
                  const Spacer(),
                  // Bottone per navigare alla schermata aggiunta spesa
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: naviga alla schermata di aggiunta spesa
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 1,
                        ),
                        child: const Text(
                          'Aggiungi Spesa',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Widget statico per creare una card con titolo e valore (usata per riepiloghi)
  static Widget _infoCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),              // Sfondo chiaro
        borderRadius: BorderRadius.circular(16),     // Angoli arrotondati
        border: Border.all(color: const Color(0xFFE0E0E0)),  // Bordo sottile
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, color: Colors.black87)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}