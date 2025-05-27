import 'dart:convert';
import 'package:http/http.dart' as http;

class StatisticheApi {
  final String baseUrl = 'http://localhost/transazioni.php';

  // Totale uscite (tipo=uscita)
  Future<double> getTotaleUscite() async {
    final response = await http.get(Uri.parse('$baseUrl?tipo=uscita'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['totale'] as num).toDouble();
    } else {
      throw Exception('Errore nel recupero della spesa totale');
    }
  }

  // Media mensile (stat=mediaMensile)
  Future<double> getMediaMensile() async {
    final response = await http.get(Uri.parse('$baseUrl?stat=mediaMensile'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['media_mensile'] as num).toDouble();
    } else {
      throw Exception('Errore nel recupero della media mensile');
    }
  }

  // Numero totale transazioni (stat=numeroTransazioni)
  Future<int> getNumeroTransazioni() async {
    final response = await http.get(Uri.parse('$baseUrl?stat=numeroTransazioni'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['numero_transazioni'] as int);
    } else {
      throw Exception('Errore nel recupero del numero di transazioni');
    }
  }
}
