import 'dart:convert';

List<Suggestion> sugestaoFromJson(List str) => List<Suggestion>.from(str.map((x) => Suggestion.fromJson(x)));

String sugestaoToJson(List<Suggestion> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Suggestion {
  Suggestion({
    this.id,
    this.sugestao,
    this.titulo,
    this.relevancia,
    this.data,
  });

  int id;
  String sugestao;
  String titulo;
  dynamic relevancia;
  DateTime data;

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
    id: json["id"],
    sugestao: json["sugestao"],
    titulo: json["titulo"],
    relevancia: json["relevancia"],
    data: DateTime.parse(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sugestao": sugestao,
    "titulo": titulo,
    "relevancia": relevancia,
    "data": data.toIso8601String(),
  };
}
