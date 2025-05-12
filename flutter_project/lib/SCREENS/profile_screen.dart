import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Schermata del profilo con stile Apple moderno
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _avatarScaleAnimation;

  @override
  void initState() {
    super.initState();
    // Inizializza l'animazione per l'avatar
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _avatarScaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.elasticOut),
    );
    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  // Mostra un dialogo di conferma per il logout
  void _showLogoutDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Logout'),
        content: const Text('Sei sicuro di voler uscire?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Annulla'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Esci'),
            onPressed: () {
              Navigator.pop(context);
              // Logica per il logout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logout effettuato!')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profilo',
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
      body: SafeArea(
        child: SingleChildScrollView(
          // Impedisce l'effetto di rimbalzo/stretch durante lo scorrimento
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                _buildAvatarSection(),
                const SizedBox(height: 20),
                _buildInfoCard(),
                const SizedBox(height: 20),
                _buildSettingsSection(),
                const SizedBox(height: 30),
                _buildLogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Sezione con avatar animato
  Widget _buildAvatarSection() {
    return ScaleTransition(
      scale: _avatarScaleAnimation!,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey, // Sostituisci con AssetImage se configurato
              // backgroundImage: AssetImage('assets/avatar.png'),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Jacob Timberli',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Text(
            'jacob@email.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // Card con informazioni personali
  Widget _buildInfoCard() {
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
          const Text(
            'Informazioni Personali',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(icon: Icons.person, label: 'Nome', value: 'Jacob Timberli'),
          const SizedBox(height: 12),
          _buildInfoRow(icon: Icons.email, label: 'Email', value: 'jacob@email.com'),
          const SizedBox(height: 12),
          _buildInfoRow(icon: Icons.phone, label: 'Telefono', value: '+39 123 456 7890'),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 20),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // Sezione con impostazioni
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
          const Text(
            'Impostazioni',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.edit,
            label: 'Modifica Profilo',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funzionalità in arrivo!')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.notifications,
            label: 'Notifiche',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funzionalità in arrivo!')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.lock,
            label: 'Privacy',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funzionalità in arrivo!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.black54),
        ],
      ),
    );
  }

  // Pulsante di logout
  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: _showLogoutDialog,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      child: const Text(
        'Logout',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}