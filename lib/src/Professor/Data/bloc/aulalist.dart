import 'package:censeo/resources/censeo_provider.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:censeo/src/Professor/Data/modal/turmastats.dart';
import 'package:censeo/src/Professor/Data/modal/turmastatsfull.dart';
import 'package:logger/logger.dart';

class BlocAulaList extends Object implements BaseBloc {
  final api = CenseoApiProvider();
  final Turma turma;

  BlocAulaList(this.turma);

  Future<List<Aula?>> fetchTurmaStats() async {
    try {
      Map result = await api.authRequest(
          type: "GET", endpoint: "/aulasTurma/${turma.id}?is_end=true");
      return aulaFromJson(result['aulas']);
    } catch (e, stack) {
      Logger().i("Request Error before realize the request", e, stack);
      return [];
    }
  }

  @override
  void dispose() {}
}

abstract class BaseBloc {
  void dispose();
}
