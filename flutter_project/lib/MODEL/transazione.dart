import 'package:json_annotation/json_annotation.dart';

part 'transazione.g.dart'; // ✅ corretto


@JsonSerializable()
class Transazione {
  final int id;
  final double importo;
  final String tipo;
  final String descrizione;
  final DateTime data;

  Transazione({
    required this.id,
    required this.importo,
    required this.tipo,
    required this.descrizione,
    required this.data,
  });

  factory Transazione.fromJson(Map<String, dynamic> json) =>
      _$TransazioneFromJson(json);

  Map<String, dynamic> toJson() => _$TransazioneToJson(this);
}
