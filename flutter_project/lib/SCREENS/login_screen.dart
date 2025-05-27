import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main_navigation_screen.dart';

// Schermata di login utente con email e password
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();    // Controller per campo email
  final TextEditingController _passwordController = TextEditingController(); // Controller per campo password
  bool _loading = false; // Stato per indicare se è in corso il login

  // Funzione per mostrare messaggi personalizzati in SnackBar
  void _showCustomSnackBar(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Funzione asincrona per effettuare il login tramite API
  Future<void> _login() async {
    final email = _emailController.text.trim();      // Prende email e rimuove spazi
    final password = _passwordController.text;        // Prende password

    // Controlla che email e password non siano vuoti
    if (email.isEmpty || password.isEmpty) {
      _showCustomSnackBar("Inserisci email e password");
      return;
    }

    setState(() => _loading = true);  // Imposta caricamento a true per bloccare pulsante e mostra spinner

    try {
      // Effettua richiesta POST all'API con email e password in JSON
      final response = await http.post(
        Uri.parse('http://localhost/htdocs/API/login.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body); // Decodifica risposta JSON

      if (data["success"]) {
        final userId = data["user"]["id"];  // Recupera l'ID utente dalla risposta

        // Salva userId nelle SharedPreferences locali per sessioni future
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', userId);

        _showCustomSnackBar("Accesso riuscito", color: Colors.green); // Mostra messaggio di successo

        // Naviga alla schermata principale sostituendo la schermata attuale
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
      } else {
        // Se login non ha successo, mostra messaggio di errore proveniente dall'API
        _showCustomSnackBar(data["message"]);
      }
    } catch (e) {
      // In caso di errori di rete o altro mostra messaggio generico
      _showCustomSnackBar("Errore di connessione al server");
    } finally {
      setState(() => _loading = false);  // Ferma animazione caricamento
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),  // Barra in alto con titolo
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Centra i widget verticalmente
          children: [
            // Campo di testo per email con icona
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Campo di testo per password, testo nascosto
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            // Bottone per inviare login, disabilitato se è in caricamento
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )  // Mostra spinner se in caricamento
                    : const Text("Login", style: TextStyle(fontSize: 16)),  // Testo bottone
              ),
            ),
          ],
        ),
      ),
    );
  }
}