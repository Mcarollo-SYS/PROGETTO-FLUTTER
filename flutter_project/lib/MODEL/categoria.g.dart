// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Categoria _$CategoriaFromJson(Map<String, dynamic> json) => Categoria(
  id: (json['id'] as num).toInt(),
  nome: json['nome'] as String,
  icona: json['icona'] as String?,
);

Map<String, dynamic> _$CategoriaToJson(Categoria instance) => <String, dynamic>{
  'id': instance.id,
  'nome': instance.nome,
  'icona': instance.icona,
};
