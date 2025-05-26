import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final int userId; // ID utente passato alla schermata Profilo

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _avatarScaleAnimation;

  bool _loading = true;               // Stato di caricamento dati
  String? _error;                    // Messaggio di errore, se presente
  Map<String, dynamic>? _userData;  // Dati utente ricevuti dal backend

  @override
  void initState() {
    super.initState();

    // Setup animazione per ingrandire l'avatar all'apertura
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _avatarScaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();

    // Avvia la chiamata per caricare i dati dell'utente
    _fetchUserData();
  }

  // Metodo che fa la richiesta HTTP per ottenere i dati del profilo
  Future<void> _fetchUserData() async {
    final url = Uri.parse('http://localhost/API/get_profile.php?user_id=${widget.userId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Se la risposta è positiva, aggiorna i dati e stato caricamento
          setState(() {
            _userData = data['user'];
            _loading = false;
          });
        } else {
          // Se risposta negativa, mostra messaggio di errore dal backend
          setState(() {
            _error = data['message'] ?? 'Errore sconosciuto';
            _loading = false;
          });
        }
      } else {
        // Se codice HTTP non è 200, segnala errore HTTP
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
  void dispose() {
    _animationController.dispose(); // Pulisce controller animazione
    super.dispose();
  }

  // Dialog per confermare il logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Sei sicuro di voler uscire?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annulla')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Esempio base: ritorna alla pagina login e rimuove la cronologia navigazione
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              // Suggerimento: qui sarebbe bene anche pulire lo SharedPreferences (user_id)
            },
            child: const Text('Esci'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mostra caricamento se i dati non sono ancora pronti
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Mostra errore se presente
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profilo')),
        body: Center(child: Text('Errore: $_error')),
      );
    }

    // Se i dati sono caricati, estrai i campi utente con sicurezza null-safe
    final nome = _userData!['nome']?.toString() ?? '';
    final email = _userData!['email']?.toString() ?? '';
    final telefono = _userData!['telefono']?.toString() ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profilo',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Avatar con animazione di scala
                ScaleTransition(
                  scale: _avatarScaleAnimation,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey,
                          // Qui potresti caricare un'immagine da rete se disponibile
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Nome utente
                      Text(
                        nome,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      // Email utente
                      Text(
                        email,
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Box con informazioni personali
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Informazioni Personali', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 12),

                      // Riga info nome
                      _buildInfoRow(icon: Icons.person, label: 'Nome', value: nome),
                      const SizedBox(height: 12),

                      // Riga info email
                      _buildInfoRow(icon: Icons.email, label: 'Email', value: email),
                      const SizedBox(height: 12),

                      // Riga info telefono
                      _buildInfoRow(icon: Icons.phone, label: 'Telefono', value: telefono),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Sezione impostazioni fittizie
                _buildSettingsSection(),

                const SizedBox(height: 30),

                // Bottone logout
                _buildLogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget per riga di info con icona, etichetta e valore allineato a destra
  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 20),
        const SizedBox(width: 12),
        Text('$label:', style: const TextStyle(fontSize: 16, color: Colors.black54)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 16, color: Colors.black87), textAlign: TextAlign.right),
        ),
      ],
    );
  }

  // Sezione impostazioni con voce modificabili (per ora solo snack bar)
  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Impostazioni', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),

          _buildSettingItem(
            icon: Icons.edit,
            label: 'Modifica Profilo',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Funzionalità in arrivo!'))),
          ),
          const SizedBox(height: 12),

          _buildSettingItem(
            icon: Icons.notifications,
            label: 'Notifiche',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Funzionalità in arrivo!'))),
          ),
          const SizedBox(height: 12),

          _buildSettingItem(
            icon: Icons.lock,
            label: 'Privacy',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Funzionalità in arrivo!'))),
          ),
        ],
      ),
    );
  }

  // Singolo elemento impostazione
  Widget _buildSettingItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.black87)),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.black54),
        ],
      ),
    );
  }

  // Bottone logout rosso
  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: _showLogoutDialog,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: const Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}