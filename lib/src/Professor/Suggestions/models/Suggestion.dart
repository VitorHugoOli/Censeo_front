import 'dart:convert';

List<Suggestion> sugestaoFromJson(List str) =>
    List<Suggestion>.from(str.map((x) => Suggestion.fromJson(x)));

String sugestaoToJson(List<Suggestion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Suggestion {
  Suggestion(
      {this.id,
      this.sugestao,
      this.titulo,
      this.relevancia,
      this.data,
      this.topico});

  int? id;
  String? sugestao;
  String? titulo;
  dynamic relevancia;
  DateTime? data;
  int? topico;

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
        id: json["id"],
        sugestao: json["sugestao"],
        titulo: json["titulo"],
        relevancia: json["relevancia"],
        data: DateTime.parse(json["data"]),
        topico: json['topico'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sugestao": sugestao,
        "titulo": titulo,
        "relevancia": relevancia,
        "data": data?.toIso8601String()??"",
        "topico": topico
      };
}
