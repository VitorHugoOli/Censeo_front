import 'dart:convert';

Map<String, List<Categories>> categoriesFromJson(Map str) =>
    str.map((k, v) => MapEntry<String, List<Categories>>(
        k, List<Categories>.from(v.map((x) => Categories.fromJson(x)))));

String categoriesToJson(Map<String, List<Categories>> data) =>
    json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(
        k, List<dynamic>.from(v.map((x) => x.toJson())))));

class Categories {
  Categories({
    this.id,
    this.sigla,
    this.nome,
    this.tipo,
    this.codigo,
  });

  int? id;
  String? sigla;
  String? nome;
  String? tipo;
  String? codigo;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json["id"],
        sigla: json["sigla"],
        nome: json["nome"],
        tipo: json["tipo"] == null ? null : json["tipo"],
        codigo: json["codigo"] == null ? null : json["codigo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sigla": sigla,
        "nome": nome,
        "tipo": tipo == null ? null : tipo,
        "codigo": codigo == null ? null : codigo,
      };
}
