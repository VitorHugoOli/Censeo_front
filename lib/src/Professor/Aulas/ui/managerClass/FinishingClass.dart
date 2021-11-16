import 'package:censeo/resources/Transformer.dart';
import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'ManagerClass.dart';

class FinishingClass extends StatefulWidget {
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
        FeatherIcons.link,
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

  @override
  _FinishingClassState createState() => _FinishingClassState();
}

class _FinishingClassState extends State<FinishingClass> {
  chooseField(label) {
    switch (label) {
      case 'Sala':
        return widget._aula.sala ?? "";
      case 'Link':
        return widget._aula.linkDocumento ?? "";
      case 'assincrona':
        return (widget._aula.isAssincrona ?? false ? "Assincrona" : "Sincrona");
      case 'Tipo':
        return widget._aula.tipoAula ?? "";
      case 'Extra':
        return widget._aula.extra![widget._aula.tipoAula] ?? "";
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
              widget._turma.disciplina?.sigla ?? "",
              style: GoogleFonts.poppins(
                color: Color(0xffffffff),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.77,
              ),
            ),
            Text(
              widget._turma.codigo ?? "",
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
            checkDisciplinaName(
                widget._turma.codigo!, widget._turma.disciplina!.nome!),
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
                widget._classBloc.endClass(idAula: widget._aula.id);
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
                  widget._aula.tema != null && widget._aula.tema!.isNotEmpty
                      ? widget._aula.tema!
                      : "Adicione um tema",
                  style: GoogleFonts.poppins(
                    color: widget._aula.tema != null &&
                            widget._aula.tema!.isNotEmpty
                        ? Color(0xff000000)
                        : Color(0x99000000),
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.49,
                  ),
                ),
                Text(
                  widget._aula.descricao != null &&
                          widget._aula.descricao!.isNotEmpty
                      ? widget._aula.descricao!
                      : "Sem descrição",
                  style: GoogleFonts.poppins(
                    color: widget._aula.descricao != null &&
                            widget._aula.descricao!.isNotEmpty
                        ? Color(0xff000000)
                        : Color(0x99000000),
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
                    builder: (context) => ManagerClass(
                        widget._aula,
                        widget._aula.turma!.codigo!,
                        widget._aula.turma!.id!,
                        widget._classBloc.bloc),
                  ),
                ).then((value) {
                  setState(() {});
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
                  DateFormat("dd/MM/yyyy").format(widget._aula.horario!),
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
                  DateFormat("kk:mm").format(widget._aula.horario!),
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
    List<Widget> list =
        FinishingClass.fields.where((e) => chooseField(e['label']) != "").map((e) {
      String field = chooseField(e['label']);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          e['icon'],
          SizedBox(
            width: 13,
          ),
          Text(
            capitalize(field),
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
    }).toList();

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
            runSpacing: 15,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: list,
          ),
          SizedBox(height: 10),
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
                        SizedBox(
                          height: 20,
                        ),
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
