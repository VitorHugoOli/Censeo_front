// To parse this JSON data, do
//
//     final turmaStats = turmaStatsFromJson(jsonString);

import 'package:censeo/src/Professor/Aulas/models/Turma.dart';

List<TurmaStats> turmaStatsFromJson(List str) =>
    List<TurmaStats>.from(str.map((x) => TurmaStats.fromJson(x)));

class TurmaStats {
  TurmaStats({
    this.id,
    this.codigo,
    this.ano,
    this.semestre,
    this.nome,
    this.sigla,
    this.curso,
    this.stats,
    this.avalsCount,
  });

  int? id;
  String? codigo;
  String? ano;
  String? semestre;
  String? nome;
  String? sigla;
  int? curso;
  Map<String, double>? stats;
  int? avalsCount;

  TurmaStats copyWith({
    int? id,
    String? codigo,
    String? ano,
    String? semestre,
    String? nome,
    String? sigla,
    int? curso,
    Map<String, double>? stats,
    int? avalsCount,
  }) =>
      TurmaStats(
        id: id ?? this.id,
        codigo: codigo ?? this.codigo,
        ano: ano ?? this.ano,
        semestre: semestre ?? this.semestre,
        nome: nome ?? this.nome,
        sigla: sigla ?? this.sigla,
        curso: curso ?? this.curso,
        stats: stats ?? this.stats,
        avalsCount: avalsCount ?? this.avalsCount,
      );

  factory TurmaStats.fromJson(Map<String, dynamic> json) => TurmaStats(
        id: json["id"],
        codigo: json["codigo"],
        ano: json["ano"],
        semestre: json["semestre"],
        nome: json["nome"],
        sigla: json["sigla"],
        curso: json["curso"],
        stats: Map.from(json["stats"])
            .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
        avalsCount: json["avals_count"],
      );

  Turma toTurma() {
    return Turma(
      id: this.id,
      codigo: this.codigo,
      ano: this.ano,
      semestre: this.semestre,
      disciplina: Disciplina(nome: this.nome, codigo: this.codigo,sigla: this.sigla),
    );
  }
}
