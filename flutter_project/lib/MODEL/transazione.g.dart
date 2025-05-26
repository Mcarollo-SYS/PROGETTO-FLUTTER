// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transazione.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transazione _$TransazioneFromJson(Map<String, dynamic> json) => Transazione(
  id: (json['id'] as num).toInt(),
  categoriaId: (json['categoria_id'] as num).toInt(),
  importo: (json['importo'] as num).toDouble(),
  tipo: $enumDecode(_$TipoTransazioneEnumMap, json['tipo']),
  descrizione: json['descrizione'] as String?,
  data: DateTime.parse(json['data'] as String),
);

Map<String, dynamic> _$TransazioneToJson(Transazione instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoria_id': instance.categoriaId,
      'importo': instance.importo,
      'tipo': _$TipoTransazioneEnumMap[instance.tipo]!,
      'descrizione': instance.descrizione,
      'data': instance.data.toIso8601String(),
    };

const _$TipoTransazioneEnumMap = {
  TipoTransazione.Entrata: 'Entrata',
  TipoTransazione.Uscita: 'Uscita',
};
