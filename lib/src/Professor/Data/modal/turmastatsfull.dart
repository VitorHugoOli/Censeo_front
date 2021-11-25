// To parse this JSON data, do
//
//     final turmaStatsFull = turmaStatsFullFromJson(jsonString);

import 'dart:convert';
import 'package:collection/collection.dart';

TurmaStatsFull turmaStatsFullFromJson(Map<String, dynamic> str) =>
    TurmaStatsFull.fromJson(str);

class TurmaStatsFull {
  TurmaStatsFull({
    this.aulas,
    this.rank,
    this.utilidade,
    this.percepo,
    this.prazer,
    this.concentrao,
    this.qualidade,
    this.aprendizagem,
    this.organizao,
    this.interao,
    this.amplitude,
    this.tarefas,
  });

  AulasStats? aulas;
  List<Rank>? rank;
  CaracteristicasStats? utilidade;
  CaracteristicasStats? percepo;
  CaracteristicasStats? prazer;
  CaracteristicasStats? concentrao;
  CaracteristicasStats? qualidade;
  CaracteristicasStats? aprendizagem;
  CaracteristicasStats? organizao;
  CaracteristicasStats? interao;
  CaracteristicasStats? amplitude;
  CaracteristicasStats? tarefas;

  static const caracteristicas = [
    "Utilidade percebida",
    "Percepção de facilidade de uso",
    "Prazer percebido/ludicidade do programa",
    "Concentração/ Relação individual",
    "Qualidade do conteúdo/Qualidade da informação",
    "Aprendizagem",
    "Organização",
    "Interação do grupo",
    "Amplitude",
    "Tarefas/Exames"
  ];

  factory TurmaStatsFull.fromJson(Map<String, dynamic> json) {
    var turma = TurmaStatsFull(
      aulas: AulasStats.fromJson(json["aulas"]),
      rank: List<Rank>.from(json["rank"].map((x) => Rank.fromJson(x))),
      utilidade: CaracteristicasStats.fromJson(json["Utilidade"]),
      percepo: CaracteristicasStats.fromJson(json["Percepção"]),
      prazer: CaracteristicasStats.fromJson(json["Prazer"]),
      concentrao: CaracteristicasStats.fromJson(json["Concentração"]),
      qualidade: CaracteristicasStats.fromJson(json["Qualidade"]),
      aprendizagem: CaracteristicasStats.fromJson(json["Aprendizagem"]),
      organizao: CaracteristicasStats.fromJson(json["Organização"]),
      interao: CaracteristicasStats.fromJson(json["Interação"]),
      amplitude: CaracteristicasStats.fromJson(json["Amplitude"]),
      tarefas: CaracteristicasStats.fromJson(json["Tarefas"]),
    );
    turma.listCaracteristicas.forEachIndexed((index, element) {
      element?.nome = caracteristicas[index];
    });
    return turma;
  }

  List<CaracteristicasStats?> get listCaracteristicas => [
        this.utilidade,
        this.percepo,
        this.prazer,
        this.concentrao,
        this.qualidade,
        this.aprendizagem,
        this.organizao,
        this.interao,
        this.amplitude,
        this.tarefas,
      ];
}

class Rank {
  Rank({
    this.id,
    this.xp,
    this.curso,
    this.userU,
    this.perfilPhoto,
    this.turmaXp,
  });

  int? id;
  String? xp;
  int? curso;
  UserU? userU;
  String? perfilPhoto;
  double? turmaXp;

  factory Rank.fromJson(Map<String, dynamic> json) => Rank(
        id: json["id"],
        xp: json["xp"],
        curso: json["curso"],
        userU: UserU.fromJson(json["user_u"]),
        perfilPhoto: json["perfilPhoto"],
        turmaXp: json["turma_xp"],
      );
}

class UserU {
  UserU({
    this.id,
    this.nome,
    this.matricula,
    this.username,
    this.email,
    this.firstTime,
    this.type,
  });

  int? id;
  String? nome;
  String? matricula;
  String? username;
  String? email;
  bool? firstTime;
  String? type;

  factory UserU.fromJson(Map<String, dynamic> json) => UserU(
        id: json["id"],
        nome: json["nome"],
        matricula: json["matricula"],
        username: json["username"],
        email: json["email"],
        firstTime: json["first_time"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "matricula": matricula,
        "username": username,
        "email": email,
        "first_time": firstTime,
        "type": type,
      };
}

class CaracteristicasStats {
  CaracteristicasStats({
    this.len,
    this.media,
    this.desvio,
    this.variancia,
    this.ultimasDezMedias,
    this.nome,
  });

  int? len;
  double? media;
  double? desvio;
  double? variancia;
  Map<String, double>? ultimasDezMedias;

  String? nome;

  factory CaracteristicasStats.fromJson(Map<String, dynamic> json) =>
      CaracteristicasStats(
        len: json["len"],
        media: json["media"].toDouble(),
        desvio: json["desvio"].toDouble(),
        variancia: json["variancia"].toDouble(),
        ultimasDezMedias: Map.from(json["ultimas_dez_medias"])
            .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      );
}

class AulasStats {
  AulasStats({
    this.total,
    this.done,
    this.teorica,
    this.prova,
    this.trabalho,
    this.excursao,
  });

  int? total;
  int? done;
  int? teorica;
  int? prova;
  int? trabalho;
  int? excursao;

  factory AulasStats.fromJson(Map<String, dynamic> json) => AulasStats(
        total: json["total"],
        done: json["done"],
        teorica: json["teorica"],
        prova: json["prova"],
        trabalho: json["trabalho"],
        excursao: json["excursao"],
      );
}
