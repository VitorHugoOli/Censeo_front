import 'package:censeo/resources/censeo_provider.dart';
import 'package:censeo/src/Aluno/Rank/bloc/provider.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:censeo/src/Professor/Data/modal/turmastats.dart';
import 'package:censeo/src/Professor/Data/modal/turmastatsfull.dart';
import 'package:logger/logger.dart';

class BlocTurmaRank extends Object implements BaseBloc {
  final api = CenseoApiProvider();
  final Turma turma;

  BlocTurmaRank(this.turma);

  Future<TurmaStatsFull?> fetchTurmaStats() async {
    try {
      Map<String, dynamic> result = await api.authRequest(
          type: 'GET', endpoint: '/turmasStats/${turma.id}');
      return turmaStatsFullFromJson(result);
    } catch (e, stack) {
      Logger().i("Request Error before realize the request", e, stack);
      return null;
    }
  }

  @override
  void dispose() {}
}

abstract class BaseBloc {
  void dispose();
}
