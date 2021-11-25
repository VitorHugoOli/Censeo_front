// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

User userFromJson(Map<String, dynamic> str) => User.fromJson(str);

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.nome,
    this.matricula,
    this.username,
    this.email,
    this.perfilPhoto,
    this.firstTime,
    this.type,
    this.token,
    this.typeId,
  });

  int? id;
  String? nome;
  String? matricula;
  String? username;
  String? email;
  String? perfilPhoto;
  bool? firstTime;
  String? type;
  String? token;
  int? typeId;

  static User? _user;


  factory User.fromJson(Map<String, dynamic> json) =>
      User(
        id: json["id"],
        nome: json["nome"],
        matricula: json["matricula"],
        username: json["username"],
        email: json["email"],
        perfilPhoto:
        json.containsKey("perfilPhoto") ? json["perfilPhoto"] : null,
        firstTime: json["first_time"],
        type: json["type"],
        token: json["token"] ?? "",
        typeId: json["typeId"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "nome": nome,
        "matricula": matricula,
        "username": username,
        "email": email,
        "first_time": firstTime,
        "type": type,
        "token": token,
        "typeId": typeId,
      };

  Map<String, dynamic> toJsonPersonalData() =>
      {
        "id": id,
        "nome": nome,
        "username": username,
        "email": email,
      };

  static Future<User?> getUser() async {
    if (_user == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _user = User.fromJson(jsonDecode(prefs.getString("user")??"{}"));
    }
    return _user;
  }
}
