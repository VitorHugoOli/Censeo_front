import 'package:censeo/resources/censeo_provider.dart';
import 'package:logger/logger.dart';

class ClassesProvider {
  final api = CenseoApiProvider();

  Future<List<String>> fetchStrikes() async {
    try {
      var response =
          await api.authRequest(type: "GET", endpoint: "/aluno/getStrikes");
      return List<String>.from(response['strikes']);
    } catch (e) {
      Logger().e(">>> Algum erro no fetchStrikes",e);
      return List.filled(7, '');
    }
  }


}
