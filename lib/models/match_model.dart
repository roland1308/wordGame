// To parse this JSON data, do
//
//     final match = matchFromJson(jsonString);

import 'dart:convert';

MatchModel matchFromJson(String str) => MatchModel.fromJson(json.decode(str));

String matchToJson(MatchModel data) => json.encode(data.toJson());

class Word {
  Word({required this.word, required this.points});

  factory Word.fromJson(json) {
    return Word(word: json["word"], points: json["ponts"]);
  }

  final String word;
  final int points;
}

class MatchModel {
  MatchModel({
    required this.letters,
    required this.words,
    required this.id,
    //required this.players,
    //required this.started,
    //required this.finished,
    //required this.startedAt,
    //required this.owner,
    //required this.finishedAt,
  });

  List<String> letters;
  List<Word> words;
  String id;
  //List<dynamic> players;
  //bool started;
  //bool finished;
  //dynamic startedAt;
  //Owner owner;
  //dynamic finishedAt;

  factory MatchModel.fromJson(Map<String, dynamic> json) => MatchModel(
        letters: List<String>.from(json["letters"].map((x) => x)),
        words: List.from(json["words"].map((item) => Word.fromJson(item))),
        id: json["id"],
        //players: List<dynamic>.from(json["players"].map((x) => x)),
        //started: json["started"],
        //finished: json["finished"],
        //startedAt: json["started_at"],
        //owner: Owner.fromJson(json["owner"]),
        //finishedAt: json["finished_at"],
      );

  Map<String, dynamic> toJson() => {
        //"players": List<dynamic>.from(players.map((x) => x)),
        //"started": started,
        //"finished": finished,
        //"started_at": startedAt,
        "letters": List<dynamic>.from(letters.map((x) => x)),
        //"owner": owner.toJson(),
        "words": List<dynamic>.from(words.map((x) => x)),
        //"finished_at": finishedAt,
        "id": id,
      };
}

class Owner {
  Owner({
    required this.position,
    required this.createdAt,
    required this.userId,
    required this.email,
  });

  Position position;
  DateTime createdAt;
  String userId;
  String email;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        position: Position.fromJson(json["position"]),
        createdAt: DateTime.parse(json["createdAt"]),
        userId: json["userId"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "position": position.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "userId": userId,
        "email": email,
      };
}

class Position {
  Position({
    required this.lng,
    required this.lat,
  });

  String lng;
  String lat;

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        lng: json["lng"],
        lat: json["lat"],
      );

  Map<String, dynamic> toJson() => {
        "lng": lng,
        "lat": lat,
      };
}
