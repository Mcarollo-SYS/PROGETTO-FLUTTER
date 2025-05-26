import 'package:json_annotation/json_annotation.dart';

part 'categoria.g.dart'; // ✅ corretto

@JsonSerializable()
class Categoria {
  final int id;
  final String nome;
  final String? icona;

  Categoria({
    required this.id,
    required this.nome,
    this.icona,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) =>
      _$CategoriaFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriaToJson(this);
}
