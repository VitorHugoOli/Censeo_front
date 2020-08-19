// To parse this JSON data, do
//
//     final aula = aulaFromJson(jsonString);

import 'dart:convert';

List<Aula> aulaFromJson(List str) => List<Aula>.from(str.map((x) => Aula.fromJson(x)));

String aulaToJson(List<Aula> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Map<DateTime, Aula> aulaToDateTime(List<Aula> data) => Aula.toDateTime(data);

class Aula {
  Aula({
    this.id,
    this.horario,
    this.sala,
    this.tipoAula,
    this.tema,
    this.descricao,
    this.linkDocumento,
  });

  int id;
  DateTime horario;
  String sala;
  dynamic tipoAula;
  dynamic tema;
  dynamic descricao;
  dynamic linkDocumento;

  factory Aula.fromJson(Map<String, dynamic> json) => Aula(
        id: json["id"],
        horario: DateTime.parse(json["horario"]),
        sala: json["sala"],
        tipoAula: json["tipo_aula"],
        tema: json["tema"],
        descricao: json["descricao"],
        linkDocumento: json["link_documento"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "horario": horario.toIso8601String(),
        "sala": sala,
        "tipo_aula": tipoAula,
        "tema": tema,
        "descricao": descricao,
        "link_documento": linkDocumento,
      };

  static Map<DateTime, Aula> toDateTime(List<Aula> aulas) {
    Map<DateTime, Aula> response = Map<DateTime, Aula>();
    for (Aula i in aulas) {
      response[DateTime(i.horario.year, i.horario.month, i.horario.day)] = i;
    }
    return response;
  }
}
