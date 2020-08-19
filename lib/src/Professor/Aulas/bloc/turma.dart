import 'dart:async';

import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:censeo/src/Professor/Aulas/ui/managerTurmas/DayDialog.dart';
import 'package:censeo/src/User/models/alunos.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../provider.dart';

class Bloc extends Object implements BaseBloc {
  final _listScheduleController = BehaviorSubject<List<ClassTime>>();
  final provider = ClassesProvider();
  final id;

  Bloc(this.id);

  Function(List<ClassTime>) get listScheduleChanged => _listScheduleController.sink.add;

  Stream<List<ClassTime>> get listSchedule => _listScheduleController.stream;

  Stream<List<Alunos>> get getAlunos async* {
    List<Alunos> alunos = List<Alunos>();
    try {
      final List openClass = await provider.fetchAlunosPerTurma(id);
      alunos = alunosFromJson(openClass);
    } catch (ex) {
      debugPrint("Exception Convert Object $ex");
    }
    yield alunos;
  }

  Stream<Map<DateTime, Aula>> get getDaysCalender async* {
    Map<DateTime, Aula> aulas = Map<DateTime, Aula>();

    try {
      final List aulasReceive = await provider.fetchAulasForTurmas(id);
      debugPrint("---");
      aulas = aulaToDateTime(aulaFromJson(aulasReceive));
    } catch (ex) {
      debugPrint("Exception Convert Object $ex");
    }
    yield aulas;
  }

  Stream<bool> get hasData => Rx.combineLatest2(getAlunos, getDaysCalender, (a, b) => true);

  Future<dynamic> submitSchedule(List<ClassTime> data, Turma turma) async {
    List<Horario> hours = data.map((e) {
      if (e.controllerTime.text.contains(":")) {
        List<String> hours = e.controllerTime.text.split(":");
        DateTime now = DateTime.now();
        DateTime time = new DateTime(now.year, now.month, now.day, int.parse(hours[0]), int.parse(hours[1]), now.second,
            now.millisecond, now.microsecond);
        e.schedule.horario = time;
        e.schedule.sala = e.controllerRoom.text;
        return e.schedule;
      } else if (e.schedule.id != null) {
        e.schedule.horario = null;
        e.schedule.sala = e.controllerRoom.text;
        return e.schedule;
      }
    }).toList()
      ..removeWhere((element) => element == null);

    List<Map> schedules = hours.map((e) => e.toJson()).toList();

    debugPrint(schedules.toString());

    Map body = {
      "idTurma": id,
      "schedules": schedules,
    };

    await provider.putClassSchedule(body);

    turma.horarios = hours.map((e) {
      print(e);
      e.dia = e.dia.substring(0, 3);
      if (e.id == null) {
        e.id = -1;
      }
      if (e.horario != null) {
        return e;
      }
    }).toList()
      ..removeWhere((element) => element == null);

  }

  @override
  void dispose() {
    _listScheduleController?.close();
    // TODO: implement dispose
  }
}

abstract class BaseBloc {
  void dispose();
}
