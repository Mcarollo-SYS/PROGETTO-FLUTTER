// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistiche.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Statistiche _$StatisticheFromJson(Map<String, dynamic> json) => Statistiche(
  spesaTotale: (json['spesa_totale'] as num).toDouble(),
  mediaMensile: (json['media_mensile'] as num).toDouble(),
  numeroTransazioni: (json['numero_transazioni'] as num).toInt(),
  speseMensili:
      (json['spese_mensili'] as List<dynamic>)
          .map((e) => SpesaMensile.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$StatisticheToJson(Statistiche instance) =>
    <String, dynamic>{
      'spesa_totale': instance.spesaTotale,
      'media_mensile': instance.mediaMensile,
      'numero_transazioni': instance.numeroTransazioni,
      'spese_mensili': instance.speseMensili,
    };

SpesaMensile _$SpesaMensileFromJson(Map<String, dynamic> json) => SpesaMensile(
  mese: json['mese'] as String,
  totale: (json['totale'] as num).toDouble(),
);

Map<String, dynamic> _$SpesaMensileToJson(SpesaMensile instance) =>
    <String, dynamic>{'mese': instance.mese, 'totale': instance.totale};
