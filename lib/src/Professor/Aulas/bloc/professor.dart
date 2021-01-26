import 'dart:async';
import 'dart:convert';

import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:censeo/src/Professor/Aulas/ui/managerTurmas/EditClassDialog.dart';
import 'package:censeo/src/User/models/alunos.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider.dart';

class Bloc extends Object implements BaseBloc {
  final provider = ClassesProvider();
  final _turmaController = BehaviorSubject<TurmaProfessor>();
  final _openClassController = BehaviorSubject<List<Aula>>();
  final _alunosController = PublishSubject<List<Alunos>>();
  final _classCalendarController = PublishSubject<Map<DateTime, Aula>>();
  final _listScheduleController = BehaviorSubject<List<ClassTime>>();
  final _horarioController = BehaviorSubject<String>();
  final _roomController = BehaviorSubject<String>();

  Function(TurmaProfessor) get turmaChanged => _turmaController.sink.add;

  Stream<TurmaProfessor> get turmaList => _turmaController.stream;

  Function(List<Aula>) get openClassChanged => _openClassController.sink.add;

  Stream<List<Aula>> get openClassList => _openClassController.stream;

  Stream<User> get user async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = User.fromJson(jsonDecode(prefs.get("user")));
    yield user;
  }

  Stream<Map<DateTime, Aula>> get getDaysCalender => _classCalendarController.stream;

  Stream<List<Alunos>> get getAlunos => _alunosController.stream;

  Function(List<ClassTime>) get listScheduleChanged => _listScheduleController.sink.add;

  Stream<List<ClassTime>> get listSchedule => _listScheduleController.stream;

  Function(String) get horarioChanged => _horarioController.sink.add;

  Stream<String> get getHorario => _horarioController.stream;

  Function(String) get roomChanged => _roomController.sink.add;

  Stream<String> get getRoom => _roomController.stream;

  Stream<bool> get submitCheck => Rx.combineLatest2(getHorario, getRoom, (e, p) {
        return (!e.isEmpty && !p.isEmpty);
      });

  fetchTurmas() async {
    final response = await provider.fetchTurmas();
    turmaChanged(turmaProfessorFromJson(response));
  }

  fetchOpenClass() async {
    List<Aula> aulas = List<Aula>();
    try {
      final List openClass = await provider.fetchOpenClass();
      aulas = aulaFromJson(openClass);
    } catch (ex) {
      print(ex);
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
    } catch (ex) {
      debugPrint("---");
      debugPrint("Exception Convert Object $ex");
    }
    _classCalendarController.sink.add(aulas);
  }

  fetchAlunos(id) async {
    List<Alunos> alunos = List<Alunos>();
    try {
      final List openClass = await provider.fetchAlunosPerTurma(id);
      print(openClass);
      alunos = alunosFromJson(openClass);
    } catch (ex, stacktrace) {
      debugPrint(">>>");
      print(stacktrace);
      debugPrint("Exception Convert Object $ex");
    }
    _alunosController.sink.add(alunos);
  }

  fetchDataTurma(id) async {
    await fetchClassCalendar(id);
    await fetchAlunos(id);
  }

  Future<dynamic> submitSchedule(int id, List<ClassTime> data) async {
    List<Map> schedules = data.map((e) {
      e.schedule.sala = e.controllerRoom.text;
      if (e.controllerTime.text.contains(":")) {
        List<String> hours = e.controllerTime.text.split(":");
        DateTime now = DateTime.now();
        e.schedule.horario = new DateTime(now.year, now.month, now.day, int.parse(hours[0]), int.parse(hours[1]));
        return e.schedule.toJson();
      } else if (e.schedule.id != null) {
        e.schedule.horario = null;
        return e.schedule.toJson();
      }
    }).toList()
      ..removeWhere((element) => element == null);

    Map body = {
      "idTurma": id,
      "schedules": schedules,
    };

    await provider.putClassSchedule(body);

    fetchTurmas();
    fetchClassCalendar(id);
  }

  submitCreateClass(int id, DateTime date) async {
    List<String> hours = _horarioController.value.split(":");
    Map body = {
      'turmaId': id,
      'time': DateTime(date.year, date.month, date.day, int.parse(hours[0]), int.parse(hours[1])).toIso8601String(),
      'room': _roomController.value,
    };

    await provider.putCreateClass(body);

    fetchClassCalendar(id);
  }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove("type");
    await prefs.remove('token');
  }

  @override
  void dispose() {
    _turmaController?.close();
    _openClassController.close();
    _alunosController?.close();
    _classCalendarController?.close();
    _listScheduleController?.close();
    _horarioController?.close();
    _roomController?.close();
  }
}

class ClassBloc extends Object implements BaseBloc {
  final Bloc bloc;
  final _temaController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();
  final _linkController = BehaviorSubject<String>();
  final _typeController = BehaviorSubject<String>();
  final _extraController = BehaviorSubject<String>();

  ClassBloc(this.bloc, {tema = '', description = '', link = '', type, extra = ''}) {
    temaChanged(tema);
    descriptionChanged(tema);
    linkChanged(link);
    typeChanged(type);
    extraChanged(extra);
    //TODO request do extra
  }

  Stream<String> get getExtra => _extraController.stream;

  Function(String) get extraChanged => _extraController.sink.add;

  Stream<String> get getType => _typeController.stream;

  Function(String) get typeChanged => _typeController.sink.add;

  Stream<String> get getLink => _linkController.stream;

  Function(String) get linkChanged => _linkController.sink.add;

  Stream<String> get getTema => _temaController.stream;

  Function(String) get temaChanged => _temaController.sink.add;

  Stream<String> get getDescription => _descriptionController.stream;

  Function(String) get descriptionChanged => _descriptionController.sink.add;

  Stream<bool> get submitCheck =>
      Rx.combineLatest5(getTema, getDescription, getLink, getType, getExtra, (e, p, c, t, o) {
        return (!e.isEmpty && !p.isEmpty && !c.isEmpty && !t.isEmpty && !o.isEmpty);
      });

  submitDeleteClass({idAula, idTurma}) {
    bloc.provider.putDeleteClass(idAula);
    bloc.fetchClassCalendar(idTurma);
  }

  submitEditClass({idAula, idTurma}) {
    Map body = {
      'tema': _temaController.value ?? "",
      'descricao': _descriptionController.value ?? "",
      'link': _linkController.value ?? "",
      'tipo': _typeController.value ?? "",
      'extra': _extraController.value,
    };

    bloc.provider.putEditClass(idAula, body);
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
    _temaController?.close();
    _descriptionController?.close();
    _linkController?.close();
    _typeController?.close();
    _extraController?.close();
    // TODO: implement dispose
  }
}

abstract class BaseBloc {
  void dispose();
}
