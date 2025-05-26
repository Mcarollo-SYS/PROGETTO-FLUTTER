import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'stats_screen.dart';
import 'add_screen.dart';
import 'profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Schermata principale con navigazione a tab (bottom navigation bar)
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int? _userId; // ID utente recuperato da SharedPreferences, opzionale perché si carica asincronamente
  int _currentIndex = 0; // Indice della schermata attiva (tab selezionato)
  late List<Widget> _screens; // Lista delle schermate corrispondenti ai tab

  // Icone da mostrare nel bottom navigation bar
  final List<IconData> _icons = [
    Icons.home,
    Icons.bar_chart,
    Icons.add_circle,
    Icons.person,
  ];

  // Etichette per ogni icona/tab
  final List<String> _labels = [
    'Home',
    'Statistiche',
    'Aggiungi',
    'Profilo',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Carica l'ID utente salvato in locale all'avvio
  }

  // Funzione asincrona per caricare l'userId da SharedPreferences
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('userId'); // Recupera userId salvato

    if (id == null) {
      // Se non esiste userId, si può decidere di mostrare login o impostare un valore di default (qui 1)
      id = 1;
    }

    // Aggiorna stato con userId e inizializza lista delle schermate
    setState(() {
      _userId = id;
      _screens = [
        const HomeScreen(),           // Schermata Home
        const StatsScreen(),          // Schermata Statistiche
        const AddScreen(),            // Schermata Aggiungi transazione/spesa
        ProfileScreen(userId: _userId!), // Schermata Profilo, passa userId dinamico
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Se userId non è ancora caricato, mostra un indicatore di caricamento
    if (_userId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Una volta caricato l'userId, mostra la UI principale con bottom navigation
    return Scaffold(
      extendBody: true, // Permette al body di estendersi dietro la barra di navigazione (utile per effetti grafici)
      body: _screens[_currentIndex], // Mostra la schermata attiva in base all'indice selezionato
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24), // Angoli arrotondati della barra
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(22, 39, 16, 209), // Ombra leggera sotto la barra
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24), // Arrotonda gli angoli anche del contenuto
          child: NavigationBar(
            height: 70,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedIndex: _currentIndex, // Evidenzia il tab selezionato
            onDestinationSelected: (index) =>
                setState(() => _currentIndex = index), // Cambia schermata quando l’utente seleziona un tab
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected, // Mostra label solo per tab attivo
            destinations: List.generate(
              _icons.length,
              (i) => NavigationDestination(
                icon: Icon(_icons[i]),
                label: _labels[i],
              ),
            ),
          ),
        ),
      ),
    );
  }
}