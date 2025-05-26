import 'package:json_annotation/json_annotation.dart';

part 'transazione.g.dart'; // ✅ corretto

enum TipoTransazione { Entrata, Uscita }

@JsonSerializable()
class Transazione {
  final int id;
  @JsonKey(name: 'categoria_id')
  final int categoriaId;
  final double importo;
  final TipoTransazione tipo;
  final String? descrizione;
  final DateTime data;

  Transazione({
    required this.id,
    required this.categoriaId,
    required this.importo,
    required this.tipo,
    this.descrizione,
    required this.data,
  });

  factory Transazione.fromJson(Map<String, dynamic> json) =>
      _$TransazioneFromJson(json);

  Map<String, dynamic> toJson() => _$TransazioneToJson(this);
}
