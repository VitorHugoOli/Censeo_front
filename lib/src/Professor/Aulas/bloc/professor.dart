import 'dart:async';
import 'dart:convert';

import 'package:censeo/resources/services/push_notification.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:censeo/src/User/models/alunos.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider.dart';

class Bloc extends Object implements BaseBloc {
  final provider = ClassesProvider();
  final _turmaController = BehaviorSubject<TurmaProfessor>();
  final _openClassController = BehaviorSubject<List<Aula>>();
  final _alunosController = PublishSubject<List<Alunos>>();
  final _classCalendarController = PublishSubject<Map<DateTime, Aula>>();
  final _horarioController = BehaviorSubject<String>();
  final _roomController = BehaviorSubject<String>();
  final _listScheduleController = BehaviorSubject<List<Horario>>();
  late GlobalKey<FormState> formKey;

  Function(TurmaProfessor) get turmaChanged => _turmaController.sink.add;

  Stream<TurmaProfessor> get turmaList => _turmaController.stream;

  Function(List<Aula>) get openClassChanged => _openClassController.sink.add;

  Stream<List<Aula>> get openClassList => _openClassController.stream;

  Stream<User> get user async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = User.fromJson(jsonDecode(prefs.get("user") as String));
    yield user;
  }

  Stream<Map<DateTime, Aula>> get getDaysCalender =>
      _classCalendarController.stream;

  Stream<List<Alunos>> get getAlunos => _alunosController.stream;

  Function(List<Horario>) get listScheduleChanged =>
      _listScheduleController.sink.add;

  Stream<List<Horario>> get listSchedule => _listScheduleController.stream;

  Function(String) get horarioChanged => _horarioController.sink.add;

  Stream<String> get getHorario => _horarioController.stream;

  Function(String) get roomChanged => _roomController.sink.add;

  Stream<String> get getRoom => _roomController.stream;

  Stream<bool> get submitCheck =>
      Rx.combineLatest2<String, String, bool>(getHorario, getRoom, (e, p) {
        return (e.isNotEmpty && p.isNotEmpty);
      });

  late User staticUser;

  Bloc() {
    upDateStaticUser().then((value) {
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

  fetchTurmas() async {
    final response = await provider.fetchTurmas();
    TurmaProfessor turma = turmaProfessorFromJson(response);
    turmaChanged(turma);
    return turma;
  }

  fetchOpenClass() async {
    List<Aula> aulas = <Aula>[];
    try {
      final List openClass = await provider.fetchOpenClass();
      aulas = aulaFromJson(openClass);
    } catch (ex, stack) {
      Logger().e("Houve um error", ex, stack);
    }
    openClassChanged(aulas);
  }

  fetchDataProf() async {
    await fetchTurmas();
    await fetchOpenClass();
  }

  fetchClassCalendar(id) async {
    Map<DateTime, Aula> aulas = Map<DateTime, Aula>();
    try {
      final List aulasReceive = await provider.fetchAulasForTurmas(id);
      aulas = aulaToDateTime(aulaFromJson(aulasReceive));
    } catch (ex, stack) {
      Logger().e("Exception Convert Object", ex, stack);
    }
    _classCalendarController.sink.add(aulas);
  }

  fetchAlunos(id) async {
    List<Alunos> alunos = <Alunos>[];
    try {
      final List openClass = await provider.fetchAlunosPerTurma(id);
      alunos = alunosFromJson(openClass);
    } catch (ex, stacktrace) {
      Logger().e("Exception Convert Object", ex, stacktrace);
    }
    _alunosController.sink.add(alunos);
  }

  fetchDataTurma(id) async {
    await fetchClassCalendar(id);
    await fetchAlunos(id);
  }

  addSchedule() {
    List<Horario> listClass = _listScheduleController.value;
    listClass.add(Horario());
    _listScheduleController.sink.add(listClass);
  }

  removeSchedule(index) {
    List<Horario> listClass = _listScheduleController.value;
    listClass.removeAt(index);
    _listScheduleController.sink.add(listClass);
  }

  Future<dynamic> submitSchedule(int id) async {
    List<Map> list =
        List<Map>.from(_listScheduleController.value.map((e) => e.toJson()));

    Map body = {
      "idTurma": id,
      "schedules": list,
    };

    await provider.putClassSchedule(body);

    TurmaProfessor turmas = await fetchTurmas();
    _listScheduleController.add(
        turmas.turmas!.firstWhere((element) => element.id == id).horarios!);
    fetchClassCalendar(id);
  }

  submitCreateClass(int id, DateTime date) async {
    List<String> hours = _horarioController.value.split(":");
    Map body = {
      'turmaId': id,
      'time': DateTime(date.year, date.month, date.day, int.parse(hours[0]),
              int.parse(hours[1]))
          .toIso8601String(),
      'room': _roomController.value,
    };

    await provider.putCreateClass(body);

    horarioChanged("");
    roomChanged("");
    fetchClassCalendar(id);
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
    _turmaController.close();
    _openClassController.close();
    _alunosController.close();
    _classCalendarController.close();
    _listScheduleController.close();
    _horarioController.close();
    _roomController.close();
  }
}

class ClassBloc extends Object implements BaseBloc {
  final Bloc bloc;
  final _temaController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();
  final _linkController = BehaviorSubject<String>();
  final _typeController = BehaviorSubject<String>();
  final _isAssincronaController = BehaviorSubject<bool>();
  final _extraController = BehaviorSubject<String>();
  final _endTimeController = BehaviorSubject<DateTime?>();

  ClassBloc(this.bloc,
      {tema = '',
      description = '',
      link = '',
      type = '',
      extra = '',
      isAssincrona = false,
      endtime}) {
    temaChanged(tema);
    descriptionChanged(tema);
    linkChanged(link);
    typeChanged(type);
    extraChanged(extra);
    isAssincronaChanged(isAssincrona);
    endTimeChanged(endtime);
  }

  Stream<String> get getExtra => _extraController.stream;

  Function(String) get extraChanged => _extraController.sink.add;

  Stream<String> get getType => _typeController.stream;

  Function(String) get typeChanged => _typeController.sink.add;

  Stream<bool> get getIsAssincrona => _isAssincronaController.stream;

  Function(bool) get isAssincronaChanged => _isAssincronaController.sink.add;

  Stream<DateTime?> get getEndTime => _endTimeController.stream;

  Function(DateTime?) get endTimeChanged => _endTimeController.sink.add;

  Stream<String> get getLink => _linkController.stream;

  Function(String) get linkChanged => _linkController.sink.add;

  Stream<String> get getTema => _temaController.stream;

  Function(String) get temaChanged => _temaController.sink.add;

  Stream<String> get getDescription => _descriptionController.stream;

  Function(String) get descriptionChanged => _descriptionController.sink.add;

  Stream<bool> get submitCheck =>
      Rx.combineLatest5<String, String, String, String, String, bool>(
          getTema, getDescription, getLink, getType, getExtra, (e, p, c, t, o) {
        return (e.isNotEmpty &&
            p.isNotEmpty &&
            c.isNotEmpty &&
            t.isNotEmpty &&
            o.isNotEmpty);
      });

  submitDeleteClass({idAula, idTurma}) async {
    await bloc.provider.putDeleteClass(idAula);
    await bloc.fetchClassCalendar(idTurma);
  }

  Future submitEditClass({idAula, idTurma}) async {
    Map body = {
      'tema': _temaController.value,
      'descricao': _descriptionController.value,
      'link': _linkController.value,
      'tipo': _typeController.value == "" ? null : _typeController.value,
      'is_assincrona': _isAssincronaController.value,
      'extra': _extraController.value,
      'end_time': _endTimeController.value?.toIso8601String() ?? "",
    };

    await bloc.provider.putEditClass(idAula, body);
    bloc.fetchClassCalendar(idTurma);
    bloc.fetchOpenClass();
  }

  endClass({idAula}) {
    Map body = {'id': idAula};
    bloc.provider.putEndClass(body);
    bloc.fetchOpenClass();
  }

  @override
  void dispose() {
    _temaController.close();
    _descriptionController.close();
    _linkController.close();
    _typeController.close();
    _extraController.close();
    // TODO: implement dispose
  }
}

abstract class BaseBloc {
  void dispose();
}
