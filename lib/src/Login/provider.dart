import 'dart:convert';

import 'package:censeo/resources/censeo_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider {
  final api = CenseoApiProvider();

  fetchLogin(body) async {
    try {
      var response = await api.withoutAuthRequest(
          type: "POST", endpoint: "/login/", body: body);
      if (response['status'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(response['user']));
        await prefs.setString("type", response['user']['type']);
        await prefs.setString('token', response['user']['token']);
      }
      return response;
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      return {"status": false, "message": "Error interno no app"};
    }
  }
}
