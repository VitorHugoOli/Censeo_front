import 'package:censeo/resources/censeo_provider.dart';
import 'package:censeo/resources/globalAlerts.dart';
import 'package:censeo/src/Professor/Suggestions/models/Suggestion.dart';

class ClassesProvider {
  final api = CenseoApiProvider();

  fetchSuggestionsCategories() async {
    try {
      var response = await api.authRequest(
          type: "GET", endpoint: "/aluno/suggestionCategories");
      return response['categorias'];
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      genericAlert();
    }
  }

  fetchTopicos(id, type) async {
    try {
      var response;
      switch (type) {
        case 'materia':
          response =
          await api.authRequest(type: "GET", endpoint: "/topicosTurma/$id");
          break;
        case 'curso':
          response =
          await api.authRequest(type: "GET", endpoint: "/topicosCurso/$id");
          break;
        case 'facu':
          response =
          await api.authRequest(type: "GET", endpoint: "/topicosFacu/$id");
          break;
      }
      return response['topicos'];
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      genericAlert();
    }
  }

  fetchSugestoes(id, type) async {
    try {
      var response;
      switch (type) {
        case 'materia':
          response = await api.authRequest(
              type: "GET", endpoint: "/sugestaoTurma/$id");
          break;
        case 'curso':
          response = await api.authRequest(
              type: "GET", endpoint: "/sugestaoCurso/$id");
          break;
        case 'facu':
          response =
          await api.authRequest(type: "GET", endpoint: "/sugestaoFacu/$id");
          break;
      }
      print(response);
      return response['suguestoes'];
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      genericAlert();
    }
  }

  createSugestoes(id, Suggestion sug, tipo) async {
    try {
      var response;
      switch (tipo) {
        case 'materia':
          response = await api.authRequest(
              type: "POST", endpoint: "/sugestaoTurma", body: sug.toJson());
          break;
        case 'curso':
          response = await api.authRequest(
              type: "POST", endpoint: "/sugestaoCurso", body: sug.toJson());
          break;
        case 'facu':
          response = await api.authRequest(
              type: "POST", endpoint: "/sugestaoFacu", body: sug.toJson());
          break;
      }
      return response['suguestoes'];
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      genericAlert();
    }
  }
}
