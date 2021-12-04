import 'dart:convert';

import 'package:word_game/models/letter_model.dart';
import 'package:word_game/models/match_model.dart';
import 'package:word_game/services/shared_prefs_service.dart';
import 'package:http/http.dart' as http;

class MatchRepo {
  String kGameBaseUrl =
      "https://us-central1-cifoflutter-982a7.cloudfunctions.net/app/api/game";

  Future<MatchModel> createMatch() async {
    var uri = Uri.parse("$kGameBaseUrl/createMatch");
    var token = await getPrefsValue("token");
    var headers = {"Authorization": token};
    http.Response response = await http.post(uri, headers: headers);
    if (response.statusCode < 300) {
      Map<String, dynamic> decoded = json.decode(response.body);
      MatchModel match = MatchModel.fromJson((decoded));
      return match;
    }
    throw Exception("Error creating match");
  }

  Future<MatchModel> startMatch(String matchId) async {
    var uri = Uri.parse("$kGameBaseUrl/start/$matchId");
    var token = await getPrefsValue("token");
    var headers = {"Authorization": token};
    http.Response response = await http.post(uri, headers: headers);
    if (response.statusCode < 300) {
      Map<String, dynamic> decoded = json.decode(response.body);
      MatchModel match = MatchModel.fromJson((decoded));
      return match;
    }
    throw Exception("Error starting match");
  }

  Future<Map<String, dynamic>> validateWord(
      String matchId, List<Letter> typedWord) async {
    String word = "";
    for (var element in typedWord) {
      word += element.letter;
    }
    var uri = Uri.parse("$kGameBaseUrl/validateWord/$matchId/$word");
    var token = await getPrefsValue("token");
    var headers = {"Authorization": token};
    http.Response response = await http.post(uri, headers: headers);
    if (response.statusCode < 300 || response.statusCode == 500) {
      Map<String, dynamic> decoded = json.decode(response.body);
      return decoded;
    }
    throw Exception("Error validating word");
  }

  Future<List<dynamic>> gameInfo(String matchId) async {
    var uri = Uri.parse("$kGameBaseUrl/$matchId");
    var token = await getPrefsValue("token");
    var headers = {"Authorization": token};
    // try {
    http.Response response = await http.get(uri, headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      print(decodedResponse["words"]);
      return decodedResponse["words"];
    } else {
      print("Error getting game info");
      return [];
    }
    // } catch (e) {
    //   throw Exception("Error $e");
    // }
  }
}
