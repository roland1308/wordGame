import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:word_game/models/user_model.dart';
import 'package:word_game/services/shared_prefs_service.dart';

class UsersRepo {
  String kBaseUrl =
      "https://us-central1-cifoflutter-982a7.cloudfunctions.net/app";

  Future<Map<String, dynamic>> updatePosition(double lat, double lng) async {
    var uri = Uri.parse("$kBaseUrl/api/updatePosition");
    var coords = {"lat": lat.toString(), "lng": lng.toString()};
    var token = await getPrefsValue("token");
    var headers = {"Authorization": token};
    try {
      http.Response response =
          await http.put(uri, body: coords, headers: headers);
      var decoded = json.decode(response.body);
      if (response.statusCode < 300) {
        return ({"success": true, "message": decoded["message"]});
      } else {
        return ({"success": false, "message": decoded["message"]});
      }
    } catch (e) {
      return ({"success": false, "message": e});
    }
  }

  Future<List<User>> getUsers() async {
    var uri = Uri.parse("$kBaseUrl/api/users");
    var token = await getPrefsValue("token");
    var headers = {"Authorization": token};
    // try {
    http.Response response = await http.get(uri, headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<Map<String, dynamic>> decodedResponse =
          List.from(jsonDecode(response.body));
      List<User> users = decodedResponse.map((e) => User.fromJson(e)).toList();
      return users;
    } else {
      throw Exception("Error requesting users");
    }
    // } catch (e) {
    //   throw Exception("Error $e");
    // }
  }
}
