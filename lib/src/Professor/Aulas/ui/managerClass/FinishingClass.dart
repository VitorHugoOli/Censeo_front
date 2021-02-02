import 'package:censeo/resources/Transformer.dart';
import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
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
  final Turma _turma;
  final ClassBloc _classBloc;

  FinishingClass(this._aula, this._turma, this._classBloc);

  static List fields = [
    {
      'label': "Sala",
      'icon': Icon(
        FeatherIcons.home,
        size: 29,
        color: Colors.black,
      ),
    },
    {
      'label': "Link",
      'icon': Icon(
        Feather.link,
        size: 29,
        color: Colors.black,
      ),
    },
    {
      'label': "assincrona",
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

  chooseField(label) {
    switch (label) {
      case 'Sala':
        return _aula?.sala ?? "";
      case 'Link':
        return _aula?.linkDocumento ?? "";
      case 'assincrona':
        return (_aula?.isAssincrona ?? false ? "Assincrona" : "Sincrona");
      case 'Tipo':
        return _aula?.tipoAula ?? "";
      case 'Extra':
        return _aula?.extra[_aula?.tipoAula] ?? "";
      default:
        return '';
    }
  }

  Widget buildNameTitle(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              _turma.disciplina.sigla,
              style: GoogleFonts.poppins(
                color: Color(0xffffffff),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.77,
              ),
            ),
            Text(
              _turma.codigo,
              style: GoogleFonts.poppins(
                color: Color(0xffffffff),
                fontSize: 11,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.49,
              ),
            )
          ],
        ),
        Container(
          width: size.width * 0.5,
          child: Text(
            checkDisciplinaName(_turma.codigo, _turma.disciplina.nome),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Color(0xffffffff),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.77,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButtonsEnd(Size size, context) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.16,
      margin: EdgeInsets.only(bottom: 20),
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

  Widget buildTop(Size size, context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Text(
                  'Descrição',
                  style: GoogleFonts.poppins(
                    color: Color(0xff000000),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.49,
                  ),
                )
              ],
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
        SizedBox(
          height: 25,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  FeatherIcons.calendar,
                  size: 28,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 13,
                ),
                Text(
                  DateFormat("dd/MM/yyyy").format(_aula.horario),
                  style: GoogleFonts.poppins(
                    color: Color(0xff000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.36,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 30,
            ),
            Row(
              children: [
                Icon(
                  FeatherIcons.clock,
                  size: 28,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 13,
                ),
                Text(
                  DateFormat("kk:mm").format(_aula.horario),
                  style: GoogleFonts.poppins(
                    color: Color(0xff000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.36,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDetailsClass(Size size, context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          buildTop(size, context),
          SizedBox(height: 20),
          Wrap(
            runSpacing: 20,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: fields.map((e) {
              String field = chooseField(e['label']);
              if (field == "") {
                return Container();
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  e['icon'],
                  SizedBox(
                    width: 13,
                  ),
                  Text(
                    Capitalize(field),
                    style: GoogleFonts.poppins(
                      color: Color(0xff000000),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.36,
                    ),
                  )
                ],
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
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        buildNameTitle(size),
                        SizedBox(height: 20,),
                        buildDetailsClass(size, context),
                      ],
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: buildButtonsEnd(size, context)))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
