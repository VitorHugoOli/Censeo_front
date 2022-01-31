import 'dart:convert';

import 'package:censeo/resources/services/push_notification.dart';
import 'package:censeo/src/Aluno/Avaliar/models/Avaliacao.dart';
import 'package:censeo/src/Aluno/Avaliar/models/Avatar.dart';
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
  late User staticUser;

  BlocAluno() {
    upDateStaticUser().then((value){
      PushNotificationService().initialise(staticUser);
    });
  }

  Future upDateStaticUser() async {
    getuser().then((value) => staticUser = value);
  }

  Future<User> getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return User.fromJson(
      jsonDecode(
        prefs.getString("user")!,
      ),
    );
  }

  updateAluno() {
    provider.updateUser(staticUser.id);
  }

  Stream<User> get user async* {
    yield await getuser();
  }

  Function(List<Aula>) get classChanged => _openClassController.sink.add;

  Stream<List<Aula>> get classList => _openClassController.stream;

  Function(Avaliacao) get avalChanged => _avaliacaoController.sink.add;

  Stream<Avaliacao> get avalList => _avaliacaoController.stream;

  Function(String) get rankChanged => _rankController.sink.add;

  Stream<String> get rankList => _rankController.stream;

  fetchOpenClass() async {
    List<Aula> aulas = <Aula>[];
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

  Future<bool> submitAvaliacao(avalId, pergId, resp, tipo,
      {end = false}) async {
    try {
      Map body = {
        'resposta': resp,
        'tipo_resposta': tipo,
        'avaliacaoId': avalId,
        'perguntaId': pergId
      };
      if (end) {
        body['end'] = end;
      }

      final bool answer = await provider.submitResposta(body);

      return answer;
    } catch (ex) {
      print(ex);
    }
    return false;
  }

  Future<List<Avatar>> fetchAvatares() async {
    try {
      List response = await provider.fetchAvatares();
      return avatarFromJson(response)
        ..insert(
            0, Avatar(avatarU: AvatarU(id: null, url: null), isActive: null));
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      return [];
    }
  }

  Future<List<Avatar>> selectAvatar(id, url) async {
    try {
      await provider.selectAvatar({"avatar_id": id});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map user = json.decode(prefs.getString("user")!);
      user["perfilPhoto"] = url;
      prefs.setString("user", json.encode(user));
      upDateStaticUser();
      return [];
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      return [];
    }
  }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove("type");
    await prefs.remove('token');
    await prefs.clear();
  }

  @override
  void dispose() {
    _openClassController.close();
    _rankController.close();
    _avaliacaoController.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
