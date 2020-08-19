import 'dart:convert';

import 'package:censeo/src/User/models/user.dart';

List<Alunos> alunosFromJson(List str) => List<Alunos>.from(str?.map((x) => Alunos.fromJson(x)) ?? []);

String alunosToJson(List<Alunos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Alunos {
  Alunos({
    this.id,
    this.xp,
    this.curso,
    this.user,
  });

  int id;
  double xp;
  int curso;
  User user;

  factory Alunos.fromJson(Map<String, dynamic> json) => Alunos(
        id: json["id"],
        xp: double.parse(json["xp"]),
        curso: json["curso"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "xp": xp,
        "curso": curso,
        "user": user.toJson(),
      };
}
