import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      'label': "Tema",
      'icon': Icon(
        FontAwesome.graduation_cap,
        size: 28,
        color: Colors.white,
      ),
    },
    {
      'label': "Descrição",
      'icon': Icon(
        Feather.info,
        size: 29,
        color: Colors.white,
      ),
    },
    {
      'label': "Link",
      'icon': Icon(
        Feather.link,
        size: 29,
        color: Colors.white,
      ),
    },
    {
      'label': "Tipo",
      'icon': Icon(
        FontAwesome.pencil,
        size: 28,
        color: Colors.white,
      ),
    },
    {
      'label': "Extra",
      'icon': Icon(
        FontAwesome.plus,
        size: 28,
        color: Colors.white,
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
                DateFormat.Md("pt_BR").format(_aula.horario),
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
                fontSize: 16,
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
                builder: (context) => ManagerClass(_aula, _aula.turma.codigo, _aula.turma.id, _classBloc.bloc),
              ),
            ).then((value) {
              print("Transforma em stateful e atualizar o _aula de acrodo com o vetor _classBloc.bloc.openClassList");
            });
          },
        )
      ],
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
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Finalizar Aula",
                style: GoogleFonts.poppins(
                  color: Color(0xffff3f85),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.63,
                ),
              ),
            ),
          ),
          Container(
            width: size.width * 0.40,
            child: RaisedButton(
              color: Color(0xff22215b),
              onPressed: () {
                _classBloc.submitDeleteClass(
                  idAula: _aula.id,
                  idTurma: idTurma,
                );
                Navigator.of(context).pop();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Cancelar Aula",
                style: GoogleFonts.poppins(
                  color: Color(0xffFF3C3C),
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

  Widget buildDetailsClass(Size size) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: size.height * 0.5,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
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
                  height: size.height * 0.08,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff6F6DD6)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: size.width * 0.2,
                        child: e['icon'],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width * 0.4,
                      child: Text(
                        e['label'],
                        style: GoogleFonts.poppins(
                          color: Color(0xff000000),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.525,
                        ),
                      ),
                    ),
                    Text(
                      field,
                      style: GoogleFonts.poppins(
                        color: Color(0xff616161),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.525,
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        }).toList(),
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
      backgroundColor: Color(0xff8552DA),
      body: Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildNameTitle(size,context),
              buildDetailsClass(size),
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
