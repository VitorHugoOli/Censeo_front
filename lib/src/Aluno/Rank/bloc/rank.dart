import 'package:censeo/resources/censeo_provider.dart';
import 'package:censeo/src/Aluno/Rank/bloc/provider.dart';
import 'package:censeo/src/Professor/Data/modal/turmastats.dart';
import 'package:logger/logger.dart';

class BlocRank extends Object implements BaseBloc {
  final provider = ClassesProvider();
  final api = CenseoApiProvider();


  Future<List<String>> getStrikes() async => await provider.fetchStrikes();

  Future<List<TurmaStats>> fetchTurmaStats() async {
    try {
      Map result =
      await api.authRequest(type: 'GET', endpoint: '/turmasStats/');
      return turmaStatsFromJson(result['turmas']);
    } catch (e,stack) {
      Logger().e("Request Error before realize the request.\n",e,stack);
      return [];
    }
  }


  @override
  void dispose() {

  }
}

abstract class BaseBloc {
  void dispose();
}
