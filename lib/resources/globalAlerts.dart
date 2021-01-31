import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';

Future<dynamic> alertNoConnection() {
  return showDialog(
    context: navigatorKey.currentState.overlay.context,
    builder: (BuildContext context) {
      Size size = MediaQuery.of(context).size;
      // retorna um objeto do tipo Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
//        title: new Text("Você não está conectado a internet"),
        content: new Container(
          child: Lottie.asset('assets/noConnection.json'),
        ),
        actionsPadding: EdgeInsets.only(right: size.width * 0.15),
        actions: <Widget>[
          // define os botões na base do dialogo
          new Container(
            width: size.width * 0.45,
            height: size.height * 0.06,
            child: RaisedButton(
              color: Color(0xff7E00DE),
              onPressed: () {
                Navigator.of(context).pop();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(76),
              ),
              child: Text(
                "Voltar",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.56,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<dynamic> alertNoServer() {
  return showDialog(
    context: navigatorKey.currentState.overlay.context,
    builder: (BuildContext context) {
      Size size = MediaQuery.of(context).size;
      // retorna um objeto do tipo Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
//        title: new Text("Você não está conectado a internet"),
        content: Container(
          height: size.height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Alguém viu o server ?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Color(0xff4b2e9d),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.56,
                ),
              ),
              Lottie.asset('assets/serverDown.json'),
            ],
          ),
        ),
        actionsPadding: EdgeInsets.only(right: size.width * 0.15),
        actions: <Widget>[
          // define os botões na base do dialogo
          new Container(
            width: size.width * 0.45,
            height: size.height * 0.06,
            child: RaisedButton(
              color: Color(0xff7E00DE),
              onPressed: () {
                Navigator.of(context).pop();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(76),
              ),
              child: Text(
                "Voltar",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.56,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<dynamic> alertNoAuth() {
  return showDialog(
    context: navigatorKey.currentState.overlay.context,
    builder: (BuildContext context) {
      Size size = MediaQuery.of(context).size;
      // retorna um objeto do tipo Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
//        title: new Text("Você não está conectado a internet"),
        content: Container(
          height: size.height * 0.5,
          child: Column(
            children: <Widget>[
              Text(
                "Humm.. você não\n estava logado",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Color(0xff0E153A),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.56,
                ),
              ),
              Lottie.asset('assets/noAuth.json', height: size.height * 0.3),
            ],
          ),
        ),
        actionsPadding: EdgeInsets.only(right: size.width * 0.15),
        actions: <Widget>[
          // define os botões na base do dialogo
          new Container(
            width: size.width * 0.45,
            height: size.height * 0.06,
            child: RaisedButton(
              color: Color(0xff7E00DE),
              onPressed: () {
                Navigator.of(context).pop();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Voltar",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.56,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<dynamic> genericAlert() {
  showDialog(
    context: navigatorKey.currentState.overlay.context,
    builder: (BuildContext context) {
      Size size = MediaQuery.of(context).size;
      // retorna um objeto do tipo Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
//        title: new Text("Você não está conectado a internet"),
        content: Container(
          height: size.height * 0.5,
          child: Column(
            children: <Widget>[
              Text(
                "Humm.. algo deu errado, tente mais tarde!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Color(0xff0E153A),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.56,
                ),
              ),
              Lottie.asset('assets/noAuth.json', height: size.height * 0.3),
            ],
          ),
        ),
        actionsPadding: EdgeInsets.only(right: size.width * 0.177),
        actions: <Widget>[
          // define os botões na base do dialogo
          new Container(
            width: size.width * 0.4,
            height: size.height * 0.06,
            child: RaisedButton(
              color: Color(0xff3D5AF1),
              onPressed: () {
                Navigator.of(context).pop();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Voltar",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.56,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
