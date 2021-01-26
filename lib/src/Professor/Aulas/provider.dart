import 'package:censeo/resources/censeo_provider.dart';
import 'package:censeo/resources/globalAlerts.dart';
import 'package:flutter/services.dart';

class ClassesProvider {
  final api = CenseoApiProvider();

  putDeleteClass(id) async {
    try {
      var response = await api.authRequest(type: "DELETE", endpoint: "/aulas/$id/");
      if (!response['status']) {
        genericAlert();
        throw('');
      }
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      genericAlert();
      throw(e);
    }
  }

  putEditClass(id, body) async {
    try {
      var response = await api.authRequest(type: "PUT", endpoint: "/aulas/$id/", body: body);
      if (!response['status']) {
        genericAlert();
        throw('');
      }
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      genericAlert();
      throw(e);
    }
  }

  putCreateClass(body) async {
    try {
      var response = await api.authRequest(type: "POST", endpoint: "/aulas/", body: body);
      if (!response['status']) {
        genericAlert();
        throw('');
      }
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      genericAlert();
      throw(e);
    }
  }

  putClassSchedule(body) async {
    try {
      var response = await api.authRequest(type: "POST", endpoint: "/schedule/", body: body);
      if (!response['status']) {
        genericAlert();
        throw('');
      }
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      genericAlert();
      throw(e);
    }
  }

  putEndClass(body) async {
    try {
      var response = await api.authRequest(type: "PUT", endpoint: "/endClass/", body: body);
      if (!response['status']) {
        genericAlert();
        throw('');
      }
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      genericAlert();
      throw(e);
    }
  }

  fetchAulasForTurmas(id) async {
    try {
      var response = await api.authRequest(type: "GET", endpoint: "/aulasTurma/$id");
      return response['aulas'];
    } catch (e) {
      print(">>> Algum erro $e");
    }
  }

  fetchOpenClass() async {
    try {
      var response = await api.withoutAuthRequest(type: "GET", endpoint: "/aulas_abertas/");
      return response['aulas'];
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      return {"status": false, "message": "Error interno no app"};
    }
  }

  fetchTurmas() async {
    try {
      var response = await api.authRequest(type: "GET", endpoint: "/turmas");
      return response;
    } catch (e) {
      print(">>> Algum erro $e, file: ");
    }
  }

  fetchAlunosPerTurma(id) async {
    try {
      var response = await api.authRequest(type: "GET", endpoint: "/turmas/$id/alunos");
      return response['alunos'];
    } catch (e) {
      print(">>> Algum erro $e");
    }
  }
}
