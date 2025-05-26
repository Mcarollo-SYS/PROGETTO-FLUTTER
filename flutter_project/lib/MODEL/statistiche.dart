import 'package:json_annotation/json_annotation.dart';

part 'statistiche.g.dart';

@JsonSerializable()
class Statistiche {
  @JsonKey(name: 'spesa_totale')
  final double spesaTotale;

  @JsonKey(name: 'media_mensile')
  final double mediaMensile;

  @JsonKey(name: 'numero_transazioni')
  final int numeroTransazioni;

  @JsonKey(name: 'spese_mensili')
  final List<SpesaMensile> speseMensili;

  Statistiche({
    required this.spesaTotale,
    required this.mediaMensile,
    required this.numeroTransazioni,
    required this.speseMensili,
  });

  factory Statistiche.fromJson(Map<String, dynamic> json) =>
      _$StatisticheFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticheToJson(this);
}

@JsonSerializable()
class SpesaMensile {
  final String mese;
  final double totale;

  SpesaMensile({
    required this.mese,
    required this.totale,
  });

  factory SpesaMensile.fromJson(Map<String, dynamic> json) =>
      _$SpesaMensileFromJson(json);

  Map<String, dynamic> toJson() => _$SpesaMensileToJson(this);
}