import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardTurma extends StatelessWidget {
  final Turma turma;

  final Widget body;

  const CardTurma({Key? key, required this.turma, required this.body})
      : super(key: key);

  Widget get title => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                turma.codigo ?? "",
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                    color: Color(0xffffffff),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.2,
                    height: 1),
              ),
              SizedBox(height: 10),
              Text(turma.disciplina?.sigla ?? "",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      color: Color(0xffffffff),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.385,
                      height: 1))
            ],
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
              ),
              child: Text(
                turma.disciplina?.nome ?? "",
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  color: Color(0xffffffff),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.56,
                  height: 1,
                ),
              ),
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, top: 14, bottom: 13),
            decoration: new BoxDecoration(
                color: Color(0xff3D5AF1),
                borderRadius: BorderRadius.circular(6)),
            child: title,
          ),
          body
        ],
      ),
    );
  }
}
