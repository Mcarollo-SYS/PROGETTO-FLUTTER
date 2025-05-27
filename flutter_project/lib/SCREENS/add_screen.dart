import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Per user_id
import 'package:intl/intl.dart'; // Per formattare la data

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController(); // NUOVO: Controller per categoria
  
  DateTime? _selectedDate; // NUOVO: Per la data selezionata
  String? _selectedType;
  bool _showSuccessBanner = false;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _iconScaleAnimation;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Imposta la data corrente come default
    // ... (resto di initState)
     _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.bounceOut),
    );
    _iconScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _descController.dispose();
    _amountController.dispose();
    _categoryController.dispose(); // NUOVO: Dispose category controller
    super.dispose();
  }

  void _showBanner() { // Non modificata
    setState(() => _showSuccessBanner = true);
    _animationController?.forward();
    Future.delayed(const Duration(seconds: 2), () {
      _animationController?.reverse().then((_) {
        if (mounted) setState(() => _showSuccessBanner = false);
      });
    });
  }

  void _showError(String msg) { // Non modificata
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // NUOVO: Funzione per mostrare il selettore data
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTransaction() async {
    final desc = _descController.text.trim();
    final amount = _amountController.text.trim();
    final category = _categoryController.text.trim(); // NUOVO: Prendi categoria
    final type = _selectedType;

    // Validazione base frontend
    if (desc.isEmpty || amount.isEmpty || type == null || _selectedDate == null || category.isEmpty) {
         _showError("Completa tutti i campi: descrizione, importo, tipo, categoria e data.");
        return;
    }
    
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      _showError("Errore: Utente non autenticato.");
      return;
    }

    // Formatta la data come YYYY-MM-DD
    final String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

    final url = Uri.parse('http://localhost/htdocs/API/adTransaction.php');

    try {
        final response = await http.post(
        url,
        body: {
            'utente_id': userId.toString(),
            'descrizione': desc,
            'importo': amount,
            'tipo': type,
            'categoria': category, 
            'data': formattedDate, 
        },
        );

        if (response.statusCode == 201) { 
        final data = json.decode(response.body);
        if (data['success'] == true) {
            _showBanner();
            _descController.clear();
            _amountController.clear();
            _categoryController.clear(); 
            setState(() {
            _selectedType = null;
            _selectedDate = DateTime.now(); // Resetta la data a oggi
            });
        } else {
            _showError(data['message'] ?? 'Errore nel salvataggio');
        }
        } else {
        _showError('Errore dal server: ${response.statusCode} - ${response.body}');
        }
    } catch (e) {
        _showError('Errore di rete: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              key: _formKey,
              child: SingleChildScrollView( // Aggiunto per evitare overflow se ci sono molti campi
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    _buildTextField(label: 'Descrizione', controller: _descController),
                    const SizedBox(height: 12),
                    _buildTextField(
                      label: 'Importo',
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true), // Permetti decimali
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(label: 'Categoria', controller: _categoryController), 
                    const SizedBox(height: 12),
                    // NUOVO: Selettore Data
                    Container(
                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                      child: ListTile(
                        title: Text(
                          _selectedDate == null
                              ? 'Seleziona Data'
                              : 'Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                           style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _pickDate(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSegmentedControl(),
                    const SizedBox(height: 30),
                    _buildSaveButton(),
                    const SizedBox(height: 12),
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
          ),
        ],
      ),
    );
  }
  

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
        groupValue: _selectedType,
        onValueChanged: (String value) {
          setState(() {
            _selectedType = value;
          });
        },
        borderColor: Colors.transparent,
        selectedColor: const Color.fromARGB(255, 96, 96, 96),
        unselectedColor: const Color(0xFFF7F8FA),
        pressedColor: Colors.grey[300],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.save, size: 20),
      label: const Text(
        'Salva',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate() && _selectedType != null && _selectedDate != null && _categoryController.text.isNotEmpty) {
          _saveTransaction();
        } else {
          _showError("Completa tutti i campi.");
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: const Color.fromARGB(255, 96, 96, 96),
        foregroundColor: Colors.white // Aggiunto per il colore del testo/icona
      ),
    );
  }

  Widget _buildSuccessBanner() { 
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 96, 96, 96),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Per far sì che il banner si adatti al contenuto
        mainAxisAlignment: MainAxisAlignment.center, // Centra il contenuto
        children: [
          ScaleTransition(
            scale: _iconScaleAnimation!,
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