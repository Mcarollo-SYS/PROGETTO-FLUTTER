import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _selectedType;
  bool _showSuccessBanner = false;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _iconScaleAnimation;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  void _showBanner() {
    setState(() {
      _showSuccessBanner = true;
    });
    _animationController?.forward();
    Future.delayed(const Duration(seconds: 2), () {
      _animationController?.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showSuccessBanner = false;
          });
        }
      });
    });
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
                  _buildTextField(label: 'Descrizione'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Importo',
                    keyboardType: TextInputType.number,
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
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextFormField(
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
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
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
        selectedColor: Colors.white,
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
      onPressed: () {
        if (_formKey.currentState!.validate() && _selectedType != null) {
          _showBanner();
        }
      },
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
            scale: _iconScaleAnimation!,
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