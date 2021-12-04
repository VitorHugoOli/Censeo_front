import 'dart:convert';

import 'package:censeo/resources/censeo_provider.dart';
import 'package:censeo/src/Professor/Data/modal/turmastats.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlocData extends Object implements BaseBloc {
  final api = CenseoApiProvider();
  final turmasController = BehaviorSubject<List<TurmaStats>>();

  Stream<User> get user async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = User.fromJson(
      jsonDecode(
        prefs.getString("user")!,
      ),
    );
    yield user;
  }

  Future fetchTurmaStats() async {
    try {
      Logger().i("Well well well");
      Map result =
      await api.authRequest(type: 'GET', endpoint: '/turmasStats/');
      turmasController.add(turmaStatsFromJson(result['turmas']));
    } catch (e) {
      Logger().i("Request Error before realize the request.\n" + ">>> $e");
    }
  }

  @override
  void dispose() {
    turmasController.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
