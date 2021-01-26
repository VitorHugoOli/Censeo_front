// To parse this JSON data, do
//
//     final turmaProfessor = turmaProfessorFromJson(jsonString);

import 'dart:convert';

TurmaProfessor turmaProfessorFromJson(Map str) => TurmaProfessor.fromJson(str);

String turmaProfessorToJson(TurmaProfessor data) => json.encode(data.toJson());

class TurmaProfessor {
  TurmaProfessor({
    this.turmas,
  });

  List<Turma> turmas;

  factory TurmaProfessor.fromJson(Map<String, dynamic> json) => TurmaProfessor(
        turmas: List<Turma>.from(json["turmas"].map((x) => Turma.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "turmas": List<dynamic>.from(turmas.map((x) => x.toJson())),
      };
}

class Turma {
  Turma({
    this.id,
    this.codigo,
    this.ano,
    this.semestre,
    this.disciplina,
    this.horarios,
  });

  int id;
  String codigo;
  String ano;
  String semestre;
  Disciplina disciplina;
  List<Horario> horarios;

  factory Turma.fromJson(Map<String, dynamic> json) => Turma(
        id: json["id"],
        codigo: json["codigo"],
        ano: json["ano"],
        semestre: json["semestre"],
        disciplina: Disciplina.fromJson(json["disciplina"]),
        horarios: json.containsKey("horarios")
            ? List<Horario>.from(json["horarios"].map((x) => Horario.fromJson(x)))
            : List<Horario>(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "codigo": codigo,
        "ano": ano,
        "semestre": semestre,
        "disciplina": disciplina.toJson(),
        "horarios": List<dynamic>.from(horarios.map((x) => x.toJson())),
      };
}

class Disciplina {
  Disciplina({
    this.id,
    this.codigo,
    this.nome,
    this.sigla,
    this.curso,
  });

  int id;
  String codigo;
  String nome;
  String sigla;
  int curso;

  factory Disciplina.fromJson(Map<String, dynamic> json) => Disciplina(
        id: json["id"],
        codigo: json["codigo"],
        nome: json["nome"],
        sigla: json["sigla"],
        curso: json["curso"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "codigo": codigo,
        "nome": nome,
        "sigla": sigla,
        "curso": curso,
      };
}

class Horario {
  Horario({
    this.id,
    this.dia,
    this.horario,
    this.sala,
  });

  int id;
  String dia;
  DateTime horario;
  String sala;

  factory Horario.fromJson(Map<String, dynamic> json) => Horario(
        id: json["id"],
        dia: json["dia"],
        horario: DateTime.parse(json["horario"]),
        sala: json["sala"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dia": dia,
        "horario": horario?.toIso8601String(),
        "sala": sala,
      };
}

class TurmaOpenClass {
  TurmaOpenClass({
    this.id,
    this.codigo,
    this.ano,
    this.semestre,
  });

  int id;
  String codigo;
  String ano;
  String semestre;

  factory TurmaOpenClass.fromJson(Map<String, dynamic> json) => TurmaOpenClass(
        id: json["id"],
        codigo: json["codigo"],
        ano: json["ano"],
        semestre: json["semestre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "codigo": codigo,
        "ano": ano,
        "semestre": semestre,
      };
}
