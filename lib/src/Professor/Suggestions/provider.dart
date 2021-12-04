import 'package:censeo/resources/censeo_provider.dart';
import 'package:censeo/resources/globalAlerts.dart';

class ClassesProvider {
  final api = CenseoApiProvider();

  fetchSuggestionsCategories() async {
    try {
      var response = await api.authRequest(
          type: "GET", endpoint: "/prof/suggestionCategories");
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
      return response['suguestoes'];
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      genericAlert();
    }
  }

  updateSugestoes(id, type, relevance) async {
    try {
      var response;
      switch (type) {
        case 'materia':
          response = await api.authRequest(
              type: "PUT",
              endpoint: "/sugestaoTurma/$id/",
              body: {"relevance": relevance});
          break;
        case 'curso':
          response = await api.authRequest(
              type: "PUT",
              endpoint: "/sugestaoCurso/$id/",
              body: {"relevance": relevance});
          break;
        case 'facu':
          response = await api.authRequest(
              type: "PUT",
              endpoint: "/sugestaoFacu/$id/",
              body: {"relevance": relevance});
          break;
      }
      return response['suguestoes'];
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      genericAlert();
    }
  }

  putTopicos(id, body, type) async {
    try {
      var response;
      switch (type) {
        case 'materia':
          response = await api.authRequest(
              type: "PUT", endpoint: "/topicosTurma/$id/", body: body);
          break;
        case 'curso':
          response = await api.authRequest(
              type: "PUT", endpoint: "/topicosCurso/$id/", body: body);
          break;
        case 'facu':
          response = await api.authRequest(
              type: "PUT", endpoint: "/topicosFacu/$id/", body: body);
          break;
      }
      return response;
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      genericAlert();
    }
  }

  deleteTopicos(id, type) async {
    try {
      var response;
      switch (type) {
        case 'materia':
          response = await api.authRequest(
              type: "DELETE", endpoint: "/topicosTurma/$id/");
          break;
        case 'curso':
          response = await api.authRequest(
              type: "DELETE", endpoint: "/topicosCurso/$id/");
          break;
        case 'facu':
          response = await api.authRequest(
              type: "DELETE", endpoint: "/topicosFacu/$id/");
          break;
      }
      return response;
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      genericAlert();
    }
  }
}
