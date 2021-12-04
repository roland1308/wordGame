// To parse this JSON data, do
//
//     final letter = letterFromJson(jsonString);

class Letter {
  Letter({
    required this.letter,
    required this.position,
  });

  String letter;
  int position;
  bool isUsed = false;
}
