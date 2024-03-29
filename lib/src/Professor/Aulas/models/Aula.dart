// To parse this JSON data, do
//
//     final aula = aulaFromJson(jsonString);

import 'dart:convert';

import 'Turma.dart';

List<Aula> aulaFromJson(List str) =>
    List<Aula>.from(str.map((x) => Aula.fromJson(x)));

String aulaToJson(List<Aula> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Map<DateTime, Aula> aulaToDateTime(List<Aula> data) => Aula.toDateTime(data);

class Aula {
  Aula(
      {this.id,
      this.horario,
      this.sala,
      this.tipoAula,
      this.tema,
      this.descricao,
      this.linkDocumento,
      this.extra,
      this.turma,
      this.isAssincrona,
      this.endTime});

  int? id;
  DateTime? horario;
  String? sala;
  String? tipoAula;
  String? tema;
  String? descricao;
  String? linkDocumento;
  Turma? turma;
  Map? extra;
  bool? isAssincrona;
  DateTime? endTime;

  factory Aula.fromJson(Map<String, dynamic> json) {
    return Aula(
      id: json["id"],
      horario: DateTime.parse(json["horario"]),
      sala: json["sala"],
      tipoAula: json["tipo_aula"] == null ? null : json["tipo_aula"],
      tema: json["tema"] == null ? null : json["tema"],
      descricao: json["descricao"] == null ? null : json["descricao"],
      linkDocumento:
          json["link_documento"] == null ? null : json["link_documento"],
      extra: json['extra'] ?? {},
      turma:
          json.containsKey("turma") ? Turma.fromJson(json["turma"]) : Turma(),
      isAssincrona: json["is_assincrona"],
      endTime: json["end_time"] == null
          ? null
          : json["end_time"] is DateTime
              ? json["end_time"]
              : DateTime.parse(json["end_time"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "horario": horario?.toIso8601String() ?? "",
        "sala": sala,
        "tipo_aula": tipoAula == null ? null : tipoAula,
        "tema": tema == null ? null : tema,
        "descricao": descricao == null ? null : descricao,
        "link_documento": linkDocumento == null ? null : linkDocumento,
        "turma": turma?.toJson() ?? "",
        "is_assincrona": isAssincrona,
        "end_time": endTime
      };

  static Map<DateTime, Aula> toDateTime(List<Aula> aulas) {
    Map<DateTime, Aula> response = Map<DateTime, Aula>();
    for (Aula i in aulas) {
      response[DateTime(i.horario!.year, i.horario!.month, i.horario!.day)] = i;
    }
    return response;
  }
}
