import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'ManagerClass.dart';

class FinishingClass extends StatelessWidget {
  final Aula _aula;
  final String siglaTurma;
  final int idTurma;
  final ClassBloc _classBloc;

  FinishingClass(this._aula, this.siglaTurma, this.idTurma, this._classBloc);

  static List fields = [
    {
      'label': "Link",
      'icon': Icon(
        Feather.link,
        size: 29,
        color: Colors.black,
      ),
    },
    {
      'label': "Sincrona",
      'icon': Icon(
        FeatherIcons.cloud,
        size: 28,
        color: Colors.black,
      ),
    },
    {
      'label': "Tipo",
      'icon': Icon(
        FeatherIcons.airplay,
        size: 28,
        color: Colors.black,
      ),
    },
    {
      'label': "Extra",
      'icon': Icon(
        FeatherIcons.plus,
        size: 28,
        color: Colors.black,
      ),
    },
  ];

  Widget buildNameTitle(Size size, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: "horario_class",
              child: Text(
                siglaTurma,
                style: GoogleFonts.poppins(
                  color: Color(0xffffffff),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.77,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                DateFormat("dd/MM").format(_aula.horario),
                style: GoogleFonts.poppins(
                  color: Color(0xffffffff),
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.49,
                ),
              ),
            ),
            Text(
              _aula.sala.toUpperCase(),
              style: GoogleFonts.poppins(
                color: Color(0xffffffff),
                fontSize: 19,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.49,
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            FontAwesome.pencil,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ManagerClass(
                    _aula, _aula.turma.codigo, _aula.turma.id, _classBloc.bloc),
              ),
            ).then((value) {
              print(
                  "Transforma em stateful e atualizar o _aula de acrodo com o vetor _classBloc.bloc.openClassList");
            });
          },
        )
      ],
    );
  }

  Widget buildTop(Size size, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5, right: 5),
                child: Column(
                  children: [
                    Text(
                      'Tema',
                      style: GoogleFonts.poppins(
                        color: Color(0xff000000),
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.49,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        'Descrição',
                        style: GoogleFonts.poppins(
                          color: Color(0xff000000),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.49,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  FeatherIcons.edit2,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManagerClass(_aula,
                          _aula.turma.codigo, _aula.turma.id, _classBloc.bloc),
                    ),
                  ).then((value) {
                    print(
                        "Transforma em stateful e atualizar o _aula de acrodo com o vetor _classBloc.bloc.openClassList");
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 5, right: 5),
                width: size.width * 0.11,
                child: Icon(
                  FeatherIcons.calendar,
                  size: 28,
                  color: Colors.black,
                ),
              ),
              Container(
                height: size.height * 0.08,
                child: Text(
                  DateFormat("dd/MM/yyyy").format(_aula.horario),
                  style: GoogleFonts.poppins(
                    color: Color(0xff000000),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.49,
                  ),
                ),
              ),
              Container(
                height: size.height * 0.08,
                width: size.width * 0.11,
                child: Icon(
                  FeatherIcons.clock,
                  size: 28,
                  color: Colors.black,
                ),
              ),
              Container(
                height: size.height * 0.08,
                child: Text(
                  DateFormat("kk:mm").format(_aula.horario),
                  style: GoogleFonts.poppins(
                    color: Color(0xff000000),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.49,
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: size.height * 0.08,
                  width: size.width * 0.11,
                  child: Icon(
                    FeatherIcons.home,
                    size: 28,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _aula.sala.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: Color(0xff000000),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.49,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonsEnd(Size size, context) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: size.width * 0.50,
            height: size.height * 0.06,
            child: RaisedButton(
              onPressed: () {
                _classBloc.endClass(idAula: _aula.id);
                Navigator.pop(context);
              },
              color: Color(0xff3D5AF1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Finalizar Aula",
                style: GoogleFonts.poppins(
                  color: Color(0xffffffff),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.63,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  chooseField(label) {
    switch (label) {
      case 'Tema':
        return _aula?.tema ?? "";
      case 'Descrição':
        return _aula?.descricao ?? "";
      case 'Link':
        return _aula?.linkDocumento ?? "";
      case 'Tipo':
        return _aula?.tipoAula ?? "";
      case 'Extra':
        return _aula?.extra[_aula?.tipoAula] ?? "";
      default:
        return '';
    }
  }

  Widget buildDetailsClass(Size size, context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: size.height * 0.7,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          buildTop(size, context),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: fields.map((e) {
              String field = chooseField(e['label']);
              return Container(
                margin: EdgeInsets.only(left: 10),
                width: size.width * 0.9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height * 0.05,
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: size.width * 0.11,
                            child: e['icon'],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      height: size.height * 0.08,
                      width: size.width * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['label'],
                            style: GoogleFonts.poppins(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.525,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xff0E153A),
      body: Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildNameTitle(size, context),
              buildDetailsClass(size, context),
              SizedBox(
                height: size.height * 0.02,
              ),
              buildButtonsEnd(size, context)
            ],
          ),
        ),
      ),
    );
  }
}
