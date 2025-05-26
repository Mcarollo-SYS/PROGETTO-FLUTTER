import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Schermata per aggiungere una nuova transazione (entrata/uscita)
class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> with SingleTickerProviderStateMixin {
  // Chiave per gestire lo stato del form e validazioni
  final _formKey = GlobalKey<FormState>();

  // Controller per gestire il testo inserito nei campi descrizione e importo
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // Variabile per memorizzare il tipo selezionato: 'entrata' o 'uscita'
  String? _selectedType;

  // Flag per mostrare/nascondere il banner di successo
  bool _showSuccessBanner = false;

  // Controller e animazioni per gestire animazioni del banner di successo
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;          // Animazione fade in/out
  Animation<Offset>? _slideAnimation;          // Animazione slide dal basso
  Animation<double>? _iconScaleAnimation;      // Animazione scala icona check

  @override
  void initState() {
    super.initState();
    // Inizializzo il controller delle animazioni con durata di 600ms
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Definisco animazione di dissolvenza
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );

    // Definisco animazione di scorrimento dal basso verso l’alto
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.bounceOut),
    );

    // Animazione per ingrandire l’icona del check verde
    _iconScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    // Pulisco controller e animazioni quando lo widget viene rimosso dalla memoria
    _animationController?.dispose();
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Funzione per mostrare il banner di successo con animazioni
  void _showBanner() {
    setState(() {
      _showSuccessBanner = true;  // Mostra il banner
    });

    _animationController?.forward(); // Avvia animazione in avanti

    // Dopo 2 secondi, fa partire l’animazione al contrario e nasconde il banner
    Future.delayed(const Duration(seconds: 2), () {
      _animationController?.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showSuccessBanner = false;  // Nasconde il banner
          });
        }
      });
    });
  }

  // Funzione per mostrare un messaggio di errore come snackbar
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // Funzione asincrona che invia i dati della transazione al backend PHP via POST
  Future<void> _saveTransaction() async {
    final desc = _descController.text.trim();       // Descrizione transazione
    final amount = _amountController.text.trim();   // Importo
    final type = _selectedType;                      // Tipo: entrata/uscita

    // Se manca qualche dato, esce senza fare nulla
    if (desc.isEmpty || amount.isEmpty || type == null) return;

    // URL endpoint PHP (attento: localhost funziona solo in emulatori, su device usa IP reale)
    final url = Uri.parse('http://localhost/htdocs/API/adTransaction.php');

    // Invio POST con i dati della transazione
    final response = await http.post(
      url,
      body: {
        'utente_id': '1',  // Qui inserisci l'ID reale dell'utente loggato
        'descrizione': desc,
        'importo': amount,
        'tipo': type,
      },
    );

    // Se la risposta è OK (200)
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        _showBanner();            // Mostra banner successo
        _descController.clear();  // Pulisce campo descrizione
        _amountController.clear(); // Pulisce campo importo
        setState(() {
          _selectedType = null;   // Deseleziona tipo transazione
        });
      } else {
        // Se backend ritorna errore, mostra messaggio
        _showError(data['message'] ?? 'Errore nel salvataggio');
      }
    } else {
      // Errore di rete o server
      _showError('Errore di rete');
    }
  }

  // Costruisce la UI principale della pagina
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Aggiungi Transazione',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,  // Chiave form per validazioni
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildTextField(label: 'Descrizione', controller: _descController),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Importo',
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _buildSegmentedControl(), // Controllo segmentato per tipo transazione
                  const SizedBox(height: 30),
                  _buildSaveButton(), // Bottone per salvare la transazione
                  const SizedBox(height: 12),
                  // Se il banner successo è attivo, mostra con animazioni
                  if (_showSuccessBanner)
                    SlideTransition(
                      position: _slideAnimation!,
                      child: FadeTransition(
                        opacity: _fadeAnimation!,
                        child: _buildSuccessBanner(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Costruisce un TextField con stile personalizzato
  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  // Costruisce il controllo segmentato Cupertino per scegliere tra 'entrata' e 'uscita'
  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: CupertinoSegmentedControl<String>(
        children: const {
          'entrata': Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text('Entrata', style: TextStyle(fontSize: 16)),
          ),
          'uscita': Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text('Uscita', style: TextStyle(fontSize: 16)),
          ),
        },
        groupValue: _selectedType, // Valore selezionato attuale
        onValueChanged: (String value) {
          setState(() {
            _selectedType = value; // Aggiorna selezione
          });
        },
        borderColor: Colors.transparent,
        selectedColor: const Color.fromARGB(255, 96, 96, 96),
        unselectedColor: const Color(0xFFF7F8FA),
        pressedColor: Colors.grey[300],
      ),
    );
  }

  // Bottone per salvare la transazione, con icona e stile personalizzato
  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.save, size: 20),
      label: const Text(
        'Salva',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onPressed: () {
        // Se il form è valido e il tipo è selezionato, salva la transazione
        if (_formKey.currentState!.validate() && _selectedType != null) {
          _saveTransaction();
        } else {
          _showError("Completa tutti i campi."); // Mostra errore se mancano dati
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: const Color.fromARGB(255, 96, 96, 96),
      ),
    );
  }

  // Widget che mostra il banner di successo con icona e testo
  Widget _buildSuccessBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 96, 96, 96),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _iconScaleAnimation!, // Animazione scala icona
            child: const Icon(Icons.check_circle, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 10),
          const Text(
            'Salvato con successo!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ],
      ),
    );
  }
}