import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descrizioneController = TextEditingController();
  final TextEditingController _importoController = TextEditingController();

  String? _selectedType; // 'entrata' o 'uscita'
  bool _showSuccessBanner = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _iconScaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    );
    _iconScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _descrizioneController.dispose();
    _importoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showBanner() {
    setState(() {
      _showSuccessBanner = true;
    });
    _animationController.forward();
    Future.delayed(const Duration(seconds: 2), () {
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showSuccessBanner = false;
          });
        }
      });
    });
  }

  Future<void> _onSave() async {
    if (_formKey.currentState!.validate() && _selectedType != null) {
      final url = Uri.parse('https://tuo-dominio.it/add_transazione.php'); // Cambia qui con il tuo URL

      final Map<String, dynamic> body = {
        'descrizione': _descrizioneController.text.trim(),
        'importo': double.parse(_importoController.text.trim()),
        'tipo': _selectedType == 'entrata' ? 'Entrata' : 'Uscita', // Maiuscole!
        'data': DateTime.now().toIso8601String().substring(0, 10), // yyyy-MM-dd
      };

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['success'] == true) {
          _showBanner();
          _descrizioneController.clear();
          _importoController.clear();
          setState(() {
            _selectedType = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Errore salvataggio: ${responseData['message']}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore di rete: $e')),
        );
      }
    } else {
      if (_selectedType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleziona tipo di transazione')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Aggiungi Transazione',
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Descrizione',
                    controller: _descrizioneController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Inserisci una descrizione';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Importo',
                    controller: _importoController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Inserisci un importo';
                      }
                      final num? importo = num.tryParse(value);
                      if (importo == null || importo <= 0) {
                        return 'Inserisci un importo valido e positivo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSegmentedControl(),
                  const SizedBox(height: 30),
                  _buildSaveButton(),
                  const SizedBox(height: 12),
                  if (_showSuccessBanner)
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
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

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
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
          labelStyle: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        validator: validator,
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
            child: Text(
              'Entrata',
              style: TextStyle(fontSize: 16),
            ),
          ),
          'uscita': Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              'Uscita',
              style: TextStyle(fontSize: 16),
            ),
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
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: _onSave,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
    );
  }

  Widget _buildSuccessBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _iconScaleAnimation,
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Transazione salvata!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}