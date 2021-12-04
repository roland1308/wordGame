
import 'dart:convert';

import 'package:http/http.dart' as http;

String kBaseUrl = "https://us-central1-cifoflutter-982a7.cloudfunctions.net/app";

class DataRepository{
  Future<String?> signUp(Map<String, dynamic> newUser) async {
    var uri = Uri.parse("$kBaseUrl/api/auth/signup");
    try {
        http.Response response = await http.post(uri, body: newUser);
        if(response.statusCode >= 200 && response.statusCode < 300){
          var decoded = json.decode(response.body);
          return(decoded["token"]);
      } else {
        throw Exception("Error signing up: ${response.body}");
      }
    } catch (e) {
      throw Exception("There was an error $e");
    }
  }

  Future<Map<String,dynamic>> signIn(Map<String, dynamic> user) async {
    var uri = Uri.parse("$kBaseUrl/api/auth/signin");
    try {
      http.Response response = await http.post(uri, body: user);
      var decoded = json.decode(response.body);
      if(response.statusCode >= 200 && response.statusCode < 300){
        return({"success": true, "token": decoded["token"]});
      } else {
        return({"success": false, "message": decoded["message"]});
      }
    } catch (e) {
      return({"success": false, "message": e});
    }
  }
}