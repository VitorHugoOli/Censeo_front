import 'dart:convert';

List<Topicos> topicosFromJson(List str) =>
    List<Topicos>.from(str.map((x) => Topicos.fromJson(x)));

String topicosToJson(List<Topicos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Topicos {
  Topicos({
    this.id,
    this.topico,
  });

  int? id;
  String? topico;

  factory Topicos.fromJson(Map<String, dynamic> json) => Topicos(
        id: json["id"],
        topico: json["topico"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "topico": topico,
      };
}
