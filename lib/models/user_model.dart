// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.userId,
    required this.email,
    required this.createdAt,
    this.position,
  });

  String userId;
  String email;
  DateTime createdAt;
  Position? position;

  factory User.fromJson(Map<String, dynamic> json) => User(
      userId: json["userId"],
      email: json["email"],
      createdAt: DateTime.parse(json["createdAt"]),
      position: json["position"] != null
          ? Position.fromJson(json["position"])
          : null);

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "createdAt": createdAt.toIso8601String(),
        "position": position?.toJson(),
      };
}

class Position {
  Position({
    required this.lat,
    required this.lng,
  });

  String lat;
  String lng;

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
