import 'package:censeo/src/Aluno/Avaliar/ui/Avaliar.dart';
import 'package:censeo/src/Aluno/Rank/ui/rank.dart';
import 'package:censeo/src/Aluno/Suggestion/ui/Categories.dart';
import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String avaliar = '/classAluno';
  static const String rank = '/rank';
  static const String sugestoes = '/suggestions';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey,required this.navigator});

  final GlobalKey<NavigatorState> navigatorKey;
  final String navigator;

  void _push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.avaliar: (context) =>
          Avaliar(onPush: (page) => _push(context, page)),
      TabNavigatorRoutes.rank: (context) =>
          RankAluno(onPush: (page) => _push(context, page)),
      TabNavigatorRoutes.sugestoes: (context) =>
          CategoriesPageAluno(onPush: (page) => _push(context, page)),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[navigator]!(context),
        );
      },
    );
  }
}
