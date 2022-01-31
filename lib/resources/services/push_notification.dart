import 'dart:io';

import 'package:censeo/main.dart';
import 'package:censeo/resources/censeo_provider.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future initialise(User user) async {
    if (Platform.isIOS) {
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        Logger().w('User granted permission: ${settings.authorizationStatus}');
      } else {
        Logger()
            .w('User NOT granted permission: ${settings.authorizationStatus}');
      }
    }

    await _handlePushToken(user);

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      Logger().i("onMessage: ${event.data}");

      if ((navigatorKey.currentState?.overlay?.context ?? null) != null) {
        Logger().i("Let's try it!");
        ScaffoldMessenger.of(navigatorKey.currentState!.overlay!.context)
            .showSnackBar(
          SnackBar(
            content: const Text('Nova aula disponível para avaliação!'),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        Logger().i("Failed show snackBar");
      }
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage event) async {
      Logger().i("onBackgroundMessage: ${event.data}");
    });
  }

  Future<void> _handlePushToken(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasPushToken = prefs.getBool('hasPushToken') ?? false;

    if (!hasPushToken) {
      String? token = await _fcm.getToken();
      if (token != null) {
        Map response = await CenseoApiProvider().authRequest(
            type: 'POST', endpoint: '/pushtoken', body: {'token': token});
        if (response['status'] == true) {
          Logger().i("Token adicionado $token");
          prefs.setBool('hasPushToken', true);
        } else {
          throw ErrorDescription(
              "Houve um erro na requisicão de adicionar o token");
        }
      }
    }
  }
}
