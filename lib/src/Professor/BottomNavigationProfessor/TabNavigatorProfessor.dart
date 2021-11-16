import 'package:censeo/src/Professor/Aulas/ui/Professor.dart';
import 'package:censeo/src/Professor/Data/ui/Data.dart';
import 'package:censeo/src/Professor/Suggestions/ui/Categories.dart';
import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String aulas = '/class';
  static const String dados = '/data';
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
      TabNavigatorRoutes.aulas: (context) =>
          Professor(onPush: (page) => _push(context, page)),
      TabNavigatorRoutes.dados: (context) =>
          Data(onPush: (page) => _push(context, page)),
      TabNavigatorRoutes.sugestoes: (context) =>
          CategoriesPage(onPush: (page) => _push(context, page))
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
