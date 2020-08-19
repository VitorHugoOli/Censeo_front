// To parse this JSON data, do
//
//     final aulasAbertas = aulasAbertasFromJson(jsonString);

import 'dart:convert';

import 'Turma.dart';

List<AulasAbertas> aulasAbertasFromJson(List str) => List<AulasAbertas>.from(str.map((x) => AulasAbertas.fromJson(x)));

String aulasAbertasToJson(List<AulasAbertas> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AulasAbertas {
  AulasAbertas({
    this.id,
    this.diaHorario,
    this.turma,
    this.sala,
  });

  int id;
  DateTime diaHorario;
  TurmaOpenClass turma;
  String sala;

  factory AulasAbertas.fromJson(Map<String, dynamic> json) => AulasAbertas(
    id: json["id"],
    diaHorario: DateTime.parse(json["dia_horario"]),
    turma: TurmaOpenClass.fromJson(json["turma"]),
    sala: json["sala"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dia_horario": diaHorario.toIso8601String(),
    "turma": turma.toJson(),
    "sala": sala,
  };
}

