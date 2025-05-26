import 'package:json_annotation/json_annotation.dart';

part 'bilancio.g.dart'; // ⬅️ Questa riga è OBBLIGATORIA

@JsonSerializable()
class Bilancio {
  final int id;
  @JsonKey(name: 'utente_id')
  final int utenteId;
  final int mese;
  final int anno;
  @JsonKey(name: 'tot_entrate')
  final double totEntrate;
  @JsonKey(name: 'tot_uscite')
  final double totUscite;
  final double saldo;

  Bilancio({
    required this.id,
    required this.utenteId,
    required this.mese,
    required this.anno,
    required this.totEntrate,
    required this.totUscite,
    required this.saldo,
  });

  factory Bilancio.fromJson(Map<String, dynamic> json) =>
      _$BilancioFromJson(json);

  Map<String, dynamic> toJson() => _$BilancioToJson(this);
}
