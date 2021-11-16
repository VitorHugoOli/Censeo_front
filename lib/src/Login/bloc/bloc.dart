import 'dart:async';
import 'dart:convert';

import 'package:censeo/src/Login/provider.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bloc extends Object implements BaseBloc {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;

  Function(String) get passwordChanged => _passwordController.sink.add;

  Stream<String> get email => _emailController.stream;

  Stream<String> get password => _passwordController.stream;

  Stream<Map> get submitCheck =>
      Rx.combineLatest2(email, password, (e, p) => {"login": e, "pass": p});

  Future<dynamic> submit(Map data) async {
    final provider = LoginProvider();
    Map credentials = await provider.fetchLogin(data);
    User user = User();
    if (credentials['status'] == true) {
      user = User.fromJson(credentials['user']);
    }

    return {
      "status": credentials["status"],
      "message": credentials["error"] ?? "",
      "user": user,
      "type": credentials.containsKey("user") ? credentials["user"]["type"] : ""
    };
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
  }
}

class BlocLogin extends Object implements BaseBloc {
  final provider = LoginProvider();
  final _userController = BehaviorSubject<User>();

  Function(User) get userChanged => _userController.sink.add;

  Stream<User> get userStream => _userController.stream;

  BlocLogin(User user) {
    _userController.add(user);
  }

  Future<dynamic> submitPersonalData(User user) async {
    Map credentials =
        await provider.updateUser(user.id, user.toJsonPersonalData());
    if (credentials['status'] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(credentials['user']));
      _userController.add(User.fromJson(credentials['user']));
      return true;
    } else {
      return credentials;
    }
  }

  Future<dynamic> submitPass(String pass) async {
    int id = _userController.value.id!;
    Map credentials =
        await provider.updateUser(id, {'pass': pass, 'first_time': false});

    if (credentials['status'] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(credentials['user']));
      User user = User.fromJson(credentials['user']);
      _userController.add(user);
      return user;
    } else {
      return credentials;
    }
  }

  @override
  void dispose() {
    _userController.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
