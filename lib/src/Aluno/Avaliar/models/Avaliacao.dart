// To parse this JSON data, do
//
//     final avaliacao = avaliacaoFromJson(jsonString);

import 'dart:convert';

Avaliacao avaliacaoFromJson(Map str) => Avaliacao.fromJson(str);

String avaliacaoToJson(Avaliacao data) => json.encode(data.toJson());

class Avaliacao {
  Avaliacao({
    this.id,
    this.aula,
    this.aluno,
    this.tipoAula,
    this.perguntas,
  });

  final int id;
  final int aula;
  final int aluno;
  final String tipoAula;
  final List<Pergunta> perguntas;

  factory Avaliacao.fromJson(Map<String, dynamic> json) => Avaliacao(
        id: json["id"],
        aula: json["aula"],
        aluno: json["aluno"],
        tipoAula: json["tipo_aula"],
        perguntas: List<Pergunta>.from(json["perguntas"].map((x) => Pergunta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "aula": aula,
        "aluno": aluno,
        "tipo_aula": tipoAula,
        "perguntas": List<dynamic>.from(perguntas.map((x) => x.toJson())),
      };
}

class Pergunta {
  Pergunta({this.id, this.questao, this.tipoQuestao, this.tipoAula, this.caracteristica});

  final int id;
  final String questao;
  final String tipoQuestao;
  final String tipoAula;
  final String caracteristica;

  factory Pergunta.fromJson(Map<String, dynamic> json) => Pergunta(
        id: json["id"],
        questao: json["questao"],
        tipoQuestao: json["tipo_questao"],
        tipoAula: json["tipo_aula"],
        caracteristica: json["caracteristica"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "questao": questao,
        "tipo_questao": tipoQuestao,
        "tipo_aula": tipoAula,
        "caracteristica": caracteristica,
      };
}
