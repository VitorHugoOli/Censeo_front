import 'dart:async';

import 'package:censeo/src/Login/provider.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object implements BaseBloc {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;

  Function(String) get passwordChanged => _passwordController.sink.add;

  Stream<String> get email => _emailController.stream;

  Stream<String> get password => _passwordController.stream;

  Stream<Map> get submitCheck => Rx.combineLatest2(email, password, (e, p) => {"login": e, "pass": p});

  Future<dynamic> submit(Map data) async {
    final provider = LoginProvider();
    Map credentials = await provider.fetchLogin(data);
    //TODO: HOW DO A LISTEN WITH AWAIT
    return {
      "status": credentials["status"],
      "message": credentials["error"] ?? "",
      "type": credentials.containsKey("user") ? credentials["user"]["type"] : ""
    };
  }

  @override
  void dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
