import 'package:censeo/resources/Avatar.dart';
import 'package:censeo/src/User/models/alunos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:google_fonts/google_fonts.dart';

class ViewAlunos {
  final List<Alunos> alunos;

  ViewAlunos(this.alunos);

  static Widget _title(context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              "Alunos Inscritos",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xff0E153A),
                fontSize: 21,
                fontWeight: FontWeight.w600,
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
                  icon: Icon(FeatherIcons.x),
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
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9))),
          title: _title(context),
          content: _body,
          actions: null,
        );
      },
    );
  }

  Widget get _body {
    return SingleChildScrollView(
      child: Center(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,

          spacing: 20,
          children: alunos
              .map((e) => Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Avatar(
                          e.perfilPhoto,
                          heightPhoto: 70,
                        ),
                        Text(e.user!.nome ?? "-",
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
                        Text(e.user!.matricula!,
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
