import 'package:censeo/resources/Avatar.dart';
import 'package:censeo/src/User/models/alunos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewAlunos {
  final List<Alunos> alunos;

  ViewAlunos(this.alunos);

  static Widget _title(context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              "Visualizar Alunos",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xff0E153A),
                fontSize: 21,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.63,
              ),
            ),
          ),
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: IconButton(
                  icon: Icon(Feather.x),
                  color: Color(0xff0E153A),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> dialog(context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9))),
          title: _title(context),
          content: _body(size),
          actions: null,
        );
      },
    );
  }

  _body(Size size) {

    return Container(
      height: 500,
      width: 100,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          children: alunos
              .map((e) => Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Avatar(
                          e.perfilPhoto,
                          heightPhoto: 70,
                        ),
                        Text(e.user.nome ?? "-",
                            style: GoogleFonts.poppins(
                              color: Color(0xff28313b),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.455,
                            )),
                        Text(e.xp.toString() + " XP",
                            style: GoogleFonts.poppins(
                              color: Color(0xff28313b),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.42,
                            )),
                        Text(e.user.matricula,
                            style: GoogleFonts.poppins(
                              color: Color(0xff787878),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.42,
                            ))
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
