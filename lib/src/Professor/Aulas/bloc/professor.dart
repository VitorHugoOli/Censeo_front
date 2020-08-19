import 'dart:async';
import 'dart:convert';

import 'package:censeo/src/Professor/Aulas/models/AulasAbertas.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider.dart';

class Bloc extends Object implements BaseBloc {
  final provider = ClassesProvider();

  Stream<User> get user async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = User.fromJson(jsonDecode(prefs.get("user")));
    yield user;
  }

  Stream<List<AulasAbertas>> get openClassList async* {
    List<AulasAbertas> aulas = List<AulasAbertas>();
    try {
      final List openClass = await provider.fetchOpenClass();
      aulas = aulasAbertasFromJson(openClass);
    } catch (ex) {
      print(ex);
    }

    yield aulas;
  }

  Stream<TurmaProfessor> get turmaList async* {
    final response = await provider.fetchTurmas();
    print("opaaa");
    yield turmaProfessorFromJson(response);
  }


  Stream<bool> get hasData => Rx.combineLatest2(user, turmaList, (a, b) => true);

  Future get updateClass async => openClassList.listen((event) {});

  @override
  void dispose() {
    // TODO: implement dispose
  }
}

abstract class BaseBloc {
  void dispose();
}
