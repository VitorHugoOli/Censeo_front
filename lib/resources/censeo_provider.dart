import 'dart:convert';
import 'dart:io';

import 'package:censeo/resources/globalAlerts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class CenseoApiProvider {
  static Client client = Client();
  static const _production = "https://censeo.herokuapp.com";
  static const _localEmulatorAndroid = "http://10.0.2.2:8000";
  static const _localEmulatorIOS = "http://127.0.0.1:8000";
  static const _local = "http://192.168.1.7:8000";
  static const _baseUrl = _production;
  Map<String, String> _headers = {"Content-type": "application/json"};

  _sharePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    if (token == null) {
      throw DontHaveToken;
    } else {
      return token;
    }
  }

  _checkWifi() async {
    // the method below returns a Future
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      alertNoConnection();
      throw ("No Connect");
    }
  }

  Future<dynamic> _baseRequest(String type, String finalUrl, body) async {
    try {
      await _checkWifi();

      final request = {
        'GET': () async =>
            await client.get(Uri.parse(finalUrl), headers: _headers),
        'POST': () async => await client.post(Uri.parse(finalUrl),
            headers: _headers, body: json.encode(body)),
        'PUT': () async => await client.put(Uri.parse(finalUrl),
            headers: _headers, body: json.encode(body)),
        'DELETE': () async =>
            await client.delete(Uri.parse(finalUrl), headers: _headers),
      };

      final req = await request[type]!();
      final reposeBody = jsonDecode(utf8.decode(req.bodyBytes));

      if (req.statusCode == 200) {
        return reposeBody;
      } else if (req.statusCode == 404) {
        print(
            ">>> Endpoint don't exist, status code: ${req.statusCode},At: $type - $finalUrl");
      } else if (req.statusCode == 401) {
        print(
            ">>> Invalid Token, status code: ${req.statusCode}, body: $reposeBody,At: $type - $finalUrl");
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("token");
        prefs.remove("user");
        alertNoAuth();
      } else {
        print(
            ">>> Response error, status code: ${req.statusCode}, body: $reposeBody,At: $type - $finalUrl");
      }
      throw ("Server Error");
    } on SocketException catch (e) {
      alertNoServer();
      print(">>> Request Error: \n>>>$e>>> At: $type - $finalUrl");
      throw ("Can't Connect to server");
    } catch (e) {
      print(">>> Request Error: \n>>>$e>>> At: $type - $finalUrl");
      throw ("Request Error");
    }
  }

  Future<dynamic> authRequest(
      {required String type, required String endpoint, body}) async {
    var finalUrl = "$_baseUrl$endpoint";
    try {
      var token = await _sharePreference();
      _headers['Authorization'] = 'Token $token';
      return _baseRequest(
        type,
        finalUrl,
        body,
      );
    } on DontHaveToken catch (_) {
      navigatorKey.currentState!
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      alertNoAuth();
      throw ("Você não está logado.");
    } catch (e) {
      throw ("Request Error before realize the request.\n" + ">>> $e");
    }
  }

  Future<dynamic> withoutAuthRequest(
      {required String type, required String endpoint, Map? body}) async {
    var finalUrl = "$_baseUrl$endpoint";
    return _baseRequest(
      type,
      finalUrl,
      body,
    );
  }
}

class DontHaveToken implements Exception {
  final String message = "Don't have token";

  String toString() => "Exception: $message";
}
