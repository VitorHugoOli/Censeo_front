import 'dart:convert';

import 'package:censeo/src/Aluno/Avaliar/models/Avaliacao.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider.dart';

class BlocAluno extends Object implements BaseBloc {
  final provider = ClassesProvider();
  final _openClassController = BehaviorSubject<List<Aula>>();
  final _rankController = BehaviorSubject<String>();
  final _avaliacaoController = BehaviorSubject<Avaliacao>();

  Stream<User> get user async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = User.fromJson(jsonDecode(prefs.get("user")));
    yield user;
  }

  Function(List<Aula>) get classChanged => _openClassController.sink.add;

  Stream<List<Aula>> get classList => _openClassController.stream;

  Function(Avaliacao) get avalChanged => _avaliacaoController.sink.add;

  Stream<Avaliacao> get avalList => _avaliacaoController.stream;

  Function(String) get rankChanged => _rankController.sink.add;

  Stream<String> get rankList => _rankController.stream;

  fetchOpenClass() async {
    List<Aula> aulas = List<Aula>();
    try {
      final List openClass = await provider.fetchOpenClass();
      aulas = aulaFromJson(openClass);
    } catch (ex) {
      print(ex);
    }
    classChanged(aulas);
  }

  Future<bool> createAvaliacao(id) async {
    Avaliacao avaliacao = Avaliacao();
    try {
      Map body = {"aulaId": id};
      final Map openClass = await provider.createAvaliacao(body);
      avaliacao = avaliacaoFromJson(openClass);
      fetchOpenClass();
    } catch (ex) {
      print(">>> Algum erro $ex");
      print(ex);
      return false;
    }
    avalChanged(avaliacao);
    return true;
  }

  Future<bool> submitAvaliacao(avalId, pergId, resp, tipo, {end = false}) async {
    try {
      Map body = {'resposta': resp, 'tipo_resposta': tipo, 'avaliacaoId': avalId, 'perguntaId': pergId};
      if (end) {
        body['end'] = end;
      }

      final bool answer = await provider.submitResposta(body);

      if (end) {
        fetchOpenClass();
      }
      return answer;
    } catch (ex) {
      print(ex);
    }
    return false;
  }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove("type");
    await prefs.remove('token');
  }

  @override
  void dispose() {
    _openClassController.close();
    _rankController.close();
    _avaliacaoController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
