import 'package:censeo/resources/CustomScrollBar.dart';
import 'package:censeo/resources/loader.dart';
import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import 'managerClass/FinishingClass.dart';
import 'managerClass/ManagerClass.dart';
import 'managerTurmas/ManagerTurma.dart';

class Professor extends StatefulWidget {
  final ValueChanged<Widget> onPush;

  Professor({this.onPush});

  @override
  _ProfessorState createState() => _ProfessorState();
}

class _ProfessorState extends State<Professor> {
  final Bloc bloc = Bloc();
  static List<String> days = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab"];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add code after super
  }

  Widget buildNameTitle(Size size) {
    return StreamBuilder<User>(
        stream: bloc.user,
        builder: (context, AsyncSnapshot<User> snapshot) {
          return Stack(
            children: [
              Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      snapshot.hasData ? snapshot.data.nome : "",
                      style: GoogleFonts.poppins(
                        color: Color(0xffffffff),
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.77,
                      ),
                    ),
                    Text(
                      "professor",
                      style: GoogleFonts.poppins(
                        color: Color(0xffffffff),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.49,
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      snapshot.hasData ? snapshot.data.nome : "",
                      style: GoogleFonts.poppins(
                        color: Color(0xffffffff),
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.77,
                      ),
                    ),
                    Text(
                      "professor",
                      style: GoogleFonts.poppins(
                        color: Color(0xffffffff),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.49,
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {
                    bloc.logOut();
                    navigatorKey.currentState.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                  },
                  icon: Icon(
                    Feather.log_out,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget buildListTurmas(Size size) {
    return StreamBuilder(
        stream: bloc.turmaList,
        builder: (context, AsyncSnapshot<TurmaProfessor> snapshot) {
          return Container(
            width: size.width * 0.9,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    itemCount: (snapshot.hasData && snapshot.data != null) ? snapshot.data.turmas.length ?? 0 : 0,
                    itemBuilder: (context, index) {
                      Turma turma = snapshot.data.turmas[index];
                      return buildCardTurmas(turma, size);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget buildCardTurmas(Turma turma, Size size) {
    Function title = () {
      return Container(
        height: size.height * 0.1,
        padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
        decoration: new BoxDecoration(color: Color(0xffff3f85), borderRadius: BorderRadius.circular(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  turma.codigo,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    color: Color(0xffffffff),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.2,
                  ),
                ),
                Text(turma.disciplina.sigla,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      color: Color(0xffffffff),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.385,
                    ))
              ],
            ),
            Container(
              width: size.width * 0.6,
              padding: EdgeInsets.only(left: 20),
              child: Text(
                turma.disciplina.nome,
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  color: Color(0xffffffff),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.56,
                ),
              ),
            )
          ],
        ),
      );
    };

    Function body = () {
      return Container(
        height: size.height * 0.12,
        margin: EdgeInsets.only(top: 2),
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: days.map((days) {
            Horario date;
            new DateFormat.yMMMd().format(new DateTime.now());
            bool hasDate = false;
            turma.horarios.forEach((element) {
              if (element.dia.toLowerCase() == days.toLowerCase()) {
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
                      color: hasDate ? Color(0xffFF3F85) : Color(0xff727272), borderRadius: BorderRadius.circular(9)),
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
                        DateFormat.Hm().format(date.horario),
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

    Function button = () {
      return Container(
        margin: EdgeInsets.only(top: 15),
        height: size.height * 0.055,
        width: size.width * 0.6,
        child: RaisedButton(
          color: Color(0xff28313b),
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManagerTurma(turma, bloc)),
            ).then((value) {
              setState(() {});
            })
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "Gerenciar",
            style: GoogleFonts.poppins(
              color: Color(0xffffffff),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.63,
            ),
          ),
        ),
      );
    };

    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      height: size.height * 0.33,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: <Widget>[title(), body(), button()],
      ),
    );
  }

  Widget buildOpenClass(Size size) {
    Function body = () {
      return StreamBuilder<List<Aula>>(
          stream: bloc.openClassList,
          builder: (context, AsyncSnapshot<List<Aula>> snapshot) {
            List<Aula> data = snapshot.data;
            return Container(
              width: size.width * 0.8,
              height: size.height * 0.27,
              child: CustomScrollbar(
                controller: _scrollController,
                isAlwaysShown: true,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    Aula item = data[index];
                    return buildOpenClassItem(size, item);
                  },
                ),
              ),
            );
          });
    };

    Function title = () {
      return Container(
        height: size.height * 0.08,
        child: Center(
          child: Text(
            "Aulas em aberto",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Color(0xff833cf8),
              fontSize: 22,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.63,
            ),
          ),
        ),
      );
    };

    return Container(
      margin: EdgeInsets.only(top: 15),
      height: size.height * 0.35,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[title(), body()],
      ),
    );
  }

  Widget buildOpenClassItem(Size size, Aula item) {
    genericText({
      String text,
      double size,
      letterSpacing = -0.35,
      FontWeight weight,
      TextAlign align,
      color = 0xffffffff,
    }) {
      return Text(
        text,
        textAlign: align,
        style: GoogleFonts.poppins(
          color: Color(color),
          fontSize: size,
          fontWeight: weight,
          fontStyle: FontStyle.normal,
          letterSpacing: letterSpacing,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FinishingClass(item, item.turma.codigo, item.turma.id, ClassBloc(bloc)),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        height: size.height * 0.042,
        decoration: new BoxDecoration(color: Color(0xff5280da), borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Hero(
              tag: "horario_class",
              child: Container(
                width: size.width * 0.23,
                child: genericText(
                    text: item.turma.codigo,
                    size: 18,
                    letterSpacing: -0.63,
                    weight: FontWeight.w600,
                    align: TextAlign.left),
              ),
            ),
            genericText(text: item.turma.codigo, size: 15, weight: FontWeight.w500, align: TextAlign.left),
            genericText(
                text: DateFormat.Hm().format(item.horario),
                size: 15,
                weight: FontWeight.w500,
                align: TextAlign.left),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          return await bloc.fetchOpenClass();
        },
        child: FutureBuilder<dynamic>(
            future: bloc.fetchDataProf(),
            builder: (context, snapshot) {
              return Loader(
                loader: (snapshot.connectionState == ConnectionState.done),
                child: SingleChildScrollView(
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff7000FF), Color(0xFF5E06CE), Color(0xFF8F00FF)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0, 0.01, 0.4951],
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 5, right: 5, top: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          buildNameTitle(size),
                          buildOpenClass(size),
                          buildListTurmas(size),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
