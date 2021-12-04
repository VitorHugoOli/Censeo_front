// To parse this JSON data, do
//
//     final avatar = avatarFromJson(jsonString);

import 'dart:convert';

List<Avatar> avatarFromJson(List str) =>
    List<Avatar>.from(str.map((x) => Avatar.fromJson(x)));

String avatarToJson(List<Avatar> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Avatar {
  Avatar({
    this.avatarU,
    this.isActive,
  });

  AvatarU? avatarU;
  bool? isActive;

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        avatarU: AvatarU.fromJson(json["avatar_u"]),
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "avatar_u": avatarU?.toJson(),
        "is_active": isActive,
      };
}

class AvatarU {
  AvatarU({
    this.id,
    this.url,
  });

  int? id;
  String? url;

  factory AvatarU.fromJson(Map<String, dynamic> json) => AvatarU(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
