// To parse this JSON data, do
//
//     final personalData = personalDataFromJson(jsonString);

import 'dart:convert';

PersonalData personalDataFromJson(String str) => PersonalData.fromJson(json.decode(str));

String personalDataToJson(PersonalData data) => json.encode(data.toJson());

class PersonalData {
  PersonalData({
    this.nome,
    this.username,
    this.email,
  });

  String nome;
  String username;
  String email;

  factory PersonalData.fromJson(Map<String, dynamic> json) => PersonalData(
    nome: json["nome"],
    username: json["username"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "nome": nome,
    "username": username,
    "email": email,
  };
}

