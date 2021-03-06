import 'package:censeo/src/Aluno/BottomNavigationProfessor/BottomNavigationBar.dart';
import 'package:censeo/src/Login/ui/Login.dart';
import 'package:censeo/src/Login/ui/personalData.dart';
import 'package:censeo/src/Professor/BottomNavigationProfessor/BottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final type = await _initialized();
  runApp(MyApp(
    type: type,
  ));
}

final Map<int, Color> colorCodesPrimary = {
  50: Color.fromRGBO(14, 21, 58, .1),
  100: Color.fromRGBO(14, 21, 58, .2),
  200: Color.fromRGBO(14, 21, 58, .3),
  300: Color.fromRGBO(14, 21, 58, .4),
  400: Color.fromRGBO(14, 21, 58, .5),
  500: Color.fromRGBO(14, 21, 58, .6),
  600: Color.fromRGBO(14, 21, 58, .7),
  700: Color.fromRGBO(14, 21, 58, .8),
  800: Color.fromRGBO(14, 21, 58, .9),
  900: Color.fromRGBO(14, 21, 58, 1),
};

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future<dynamic> _initialized() async {
  print(">>> _initialized runing...");
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("token")) {
    return prefs.get("type");
  } else {
    return null;
  }
}

BuildContext globalContext;

class MyApp extends StatelessWidget {
  final String type;
  static final initRoutes = {
    "Professor": "/professor",
    null: "/",
    "Aluno": "/aluno"
  };

  MyApp({@required this.type});

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return MaterialApp(
      title: 'Censeo',
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        const Locale('pt', 'BR'), // English
      ],
      initialRoute: initRoutes[type],
      theme: ThemeData(
          primarySwatch: MaterialColor(0xff0E153A, colorCodesPrimary),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cursorColor: Color.fromRGBO(14, 21, 58, 1),
          fontFamily: GoogleFonts.poppins().toString()),
      navigatorKey: navigatorKey,
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => new Login(),
        "/professor": (BuildContext context) => new BottomNavigationProfessor(),
        "/aluno": (BuildContext context) => new BottomNavigationAluno(),
      },
    );
  }
}
