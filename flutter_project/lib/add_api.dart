import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_project/MODEL/transazione.dart';

class AddApi {
  final String baseUrl = 'http://localhost/transazioni.php';

  Future<bool> aggiungiTransazione(Transazione transazione) async {
    final url = Uri.parse(baseUrl);

    final body = json.encode(transazione.toJson());

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['success'] == true;
    } else {
      throw Exception('Errore nell\'inserimento transazione');
    }
  }
}
