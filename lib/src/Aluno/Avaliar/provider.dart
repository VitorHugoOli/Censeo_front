import 'package:censeo/resources/censeo_provider.dart';

class ClassesProvider {
  final api = CenseoApiProvider();

  fetchOpenClass() async {
    try {
      var response =
          await api.authRequest(type: "GET", endpoint: "/alunoAulas/");
      return response['aulas'];
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      return {"status": false, "message": "Error interno no app"};
    }
  }

  createAvaliacao(body) async {
    try {
      var response = await api.authRequest(
          type: "POST", endpoint: "/avaliacao/", body: body);
      return response['avaliacao'];
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      return {"status": false, "message": "Error interno no app"};
    }
  }

  submitResposta(body) async {
    try {
      var response = await api.authRequest(
          type: "POST", endpoint: "/resposta/", body: body);
      return response['status'];
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      return {"status": false, "message": "Error interno no app"};
    }
  }

  fetchAvatares() async {
    try {
      var response = await api.authRequest(type: "GET", endpoint: "/avatar/");
      return response['data'];
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      return {"status": false, "message": "Error interno no app"};
    }
  }

  selectAvatar(body) async {
    try {
      var response =
          await api.authRequest(type: "POST", endpoint: "/avatar/", body: body);
      return response['status'];
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      return {"status": false, "message": "Error interno no app"};
    }
  }

  updateUser(id) async {
    try {
      var response = await api.authRequest(type: "GET", endpoint: "/user/$id");
      print(response);
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      return {"status": false, "message": "Error interno no app"};
    }
  }
}
