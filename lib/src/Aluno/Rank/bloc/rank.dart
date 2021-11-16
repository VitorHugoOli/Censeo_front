import 'package:censeo/src/Aluno/Rank/bloc/provider.dart';

class BlocRank extends Object implements BaseBloc {
  final provider = ClassesProvider();

  Future<List<String>> getStrikes() async => await provider.fetchStrikes();


  @override
  void dispose() {

  }
}

abstract class BaseBloc {
  void dispose();
}
