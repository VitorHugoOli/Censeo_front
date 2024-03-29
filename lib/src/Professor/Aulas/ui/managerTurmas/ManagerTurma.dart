import 'package:censeo/resources/Avatar.dart';
import 'package:censeo/resources/Transformer.dart';
import 'package:censeo/resources/loader.dart';
import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:censeo/src/Professor/Aulas/ui/managerTurmas/EditClassDialog.dart';
import 'package:censeo/src/User/models/alunos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'Calendar.dart';
import 'DialogViewAlunos.dart';

class ManagerTurma extends StatefulWidget {
  final Turma _turma;
  final Bloc bloc;

  ManagerTurma(this._turma, this.bloc);

  @override
  _ManagerTurmaState createState() => _ManagerTurmaState();
}

class _ManagerTurmaState extends State<ManagerTurma> {
  static const List<String> days = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab"];

  @override
  void initState() {
    super.initState();
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

  Widget buildAlunos(size) {
    Function title = () {
      return Container(
        child: Center(
          child: Text(
            "Alunos",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Color(0xff28313b),
              fontSize: 22,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.63,
            ),
          ),
        ),
      );
    };

    Function body = () {
      return Container(
        width: size.width * 0.8,
        child: Center(
          child: StreamBuilder<List<Alunos>>(
              stream: widget.bloc.getAlunos,
              initialData: [],
              builder: (context, AsyncSnapshot<List<Alunos>> snapshot) {
                List<Alunos> data = snapshot.data ?? [];

                data.sort((a, b) {
                  return b.xp!.compareTo(a.xp!);
                });

                if (data.length > 3) {
                  data = snapshot.data!.sublist(0, 3);
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: data
                      .map((e) => Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Avatar(
                                  e.perfilPhoto,
                                  heightPhoto: 70,
                                ),
                                Text(e.user?.nome ?? "",
                                    style: GoogleFonts.poppins(
                                      color: Color(0xff28313b),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
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
                                Text(e.user?.matricula ?? "",
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
                );
              }),
        ),
      );
    };

    Function button = () {
      return Container(
        height: size.height * 0.07,
        width: size.width * 0.8,
        child: StreamBuilder<List<Alunos>>(
            stream: widget.bloc.getAlunos,
            builder: (context, snapshot) {
              List<Alunos> list = <Alunos>[];
              if (snapshot.hasData) {
                list.addAll(snapshot.data!);
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      ViewAlunos(list).dialog(context);
                    },
                    child: Text("Ver Mais",
                        style: GoogleFonts.poppins(
                          color: Color(0xff28313b),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.63,
                        )),
                  ),
                ],
              );
            }),
      );
    };

    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 30),
      height: size.height * 0.33,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[title(), body(), button()],
      ),
    );
  }

  Widget buildCalendar(size) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 340,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: StreamBuilder<Map<DateTime, Aula>>(
          stream: widget.bloc.getDaysCalender,
          initialData: {},
          builder: (context, AsyncSnapshot<Map<DateTime, Aula>> snapshot) {
            return Calendar(
              aulas: snapshot.data ?? {},
              bloc: widget.bloc,
              turma: widget._turma,
            );
          }),
    );
  }

  Widget buildProgDays(size) {
    dialogEditClass(Turma turma) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          Size size = MediaQuery.of(context).size;
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            title: EditClassDialog.title(context),
            content: EditClassDialog(turma.horarios!, turma.id!, widget.bloc),
            actions:
                EditClassDialog.actions(context, turma.id!, size, widget.bloc),
          );
        },
      );
    }

    Function body = (Turma turma) {
      return Container(
        height: size.height * 0.12,
        margin: EdgeInsets.only(top: 2),
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: days.map((days) {
            late Horario date;
            new DateFormat.yMMMd().format(new DateTime.now());
            bool hasDate = false;
            turma.horarios?.forEach((element) {
              if (element.dia!.toLowerCase() == days.toLowerCase()) {
                date = element;
                hasDate = true;
              }
            });
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: new BoxDecoration(
                      color: hasDate ? Color(0xff0E153A) : Color(0xff727272),
                      borderRadius: BorderRadius.circular(9)),
                  child: Center(
                    child: Text(
                      days,
                      style: GoogleFonts.poppins(
                        color: Color(0xffffffff),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.63,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                hasDate
                    ? Text(
                        date.horario != null
                            ? DateFormat.Hm().format(date.horario!)
                            : "",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xff383838),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.455,
                        ),
                      )
                    : Container(
                        height: 14,
                      )
              ],
            );
          }).toList(),
        ),
      );
    };

    Function title = () {
      return Container(
        height: size.height * 0.07,
        child: Center(
          child: Text(
            "Dias programados",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Color(0xff28313b),
              fontSize: 22,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.63,
            ),
          ),
        ),
      );
    };

    Function button = (Turma turma) {
      return Container(
        height: size.height * 0.07,
        width: size.width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => dialogEditClass(turma),
              child: Text("Editar",
                  style: GoogleFonts.poppins(
                    color: Color(0xff28313b),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.63,
                  )),
            ),
          ],
        ),
      );
    };

    return Container(
      margin: EdgeInsets.only(top: 15),
      height: size.height * 0.27,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: StreamBuilder(
          stream: widget.bloc.turmaList,
          builder: (context, AsyncSnapshot<TurmaProfessor> snapshot) {
            Turma thisTurma = Turma();
            if (snapshot.hasData) {
              snapshot.data?.turmas?.forEach((element) {
                if (element.id == widget._turma.id) {
                  thisTurma = element;
                }
              });
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[title(), body(thisTurma), button(thisTurma)],
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: widget.bloc.fetchDataTurma(widget._turma.id),
      builder: (context, snapshot) {
        return Loader(
          loader: (snapshot.connectionState == ConnectionState.done),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: Color(0xff0E153A),
            body: SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(left: 5, right: 5, top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buildNameTitle(size),
                  buildProgDays(size),
                  buildCalendar(size),
                  buildAlunos(size),
                ],
              ),
            )),
          ),
        );
      },
    );
  }
}
