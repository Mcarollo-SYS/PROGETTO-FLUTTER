// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bilancio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bilancio _$BilancioFromJson(Map<String, dynamic> json) => Bilancio(
  id: (json['id'] as num).toInt(),
  utenteId: (json['utente_id'] as num).toInt(),
  mese: (json['mese'] as num).toInt(),
  anno: (json['anno'] as num).toInt(),
  totEntrate: (json['tot_entrate'] as num).toDouble(),
  totUscite: (json['tot_uscite'] as num).toDouble(),
  saldo: (json['saldo'] as num).toDouble(),
);

Map<String, dynamic> _$BilancioToJson(Bilancio instance) => <String, dynamic>{
  'id': instance.id,
  'utente_id': instance.utenteId,
  'mese': instance.mese,
  'anno': instance.anno,
  'tot_entrate': instance.totEntrate,
  'tot_uscite': instance.totUscite,
  'saldo': instance.saldo,
};
