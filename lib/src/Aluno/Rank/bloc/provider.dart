import 'package:censeo/resources/censeo_provider.dart';

class ClassesProvider {
  final api = CenseoApiProvider();

  Future<List<String>> fetchStrikes() async {
    try {
      var response =
          await api.authRequest(type: "GET", endpoint: "/aluno/getStrikes");
      return List<String>.from(response['strikes']);
    } catch (e) {
      print(">>> Algum erro $e, file: ");
      return List.filled(7, '');
    }
  }
}
