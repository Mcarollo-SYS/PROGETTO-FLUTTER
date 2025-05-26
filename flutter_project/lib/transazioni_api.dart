import 'dart:convert';
import 'package:flutter_project/MODEL/transazione.dart';
import 'package:http/http.dart' as http;

class TransazioniApi {
  final String baseUrl = 'http://localhost/transazioni.php';

  Future<double> getTotEntrate() async {
    final response = await http.get(Uri.parse('$baseUrl?tipo=entrata'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['totale'] as num).toDouble();
    } else {
      throw Exception('Errore nel recupero entrate');
    }
  }

  Future<double> getTotUscite() async {
    final response = await http.get(Uri.parse('$baseUrl?tipo=uscita'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['totale'] as num).toDouble();
    } else {
      throw Exception('Errore nel recupero uscite');
    }
  }

  Future<List<Transazione>> getTransazion() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Transazione.fromJson(json)).toList();
    } else {
      throw Exception('Errore');
    }
  }
}
