import 'package:censeo/resources/cardturma/cardTurma.dart';
import 'package:censeo/resources/loader.dart';
import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import 'managerClass/FinishingClass.dart';
import 'managerTurmas/ManagerTurma.dart';

class Professor extends StatefulWidget {
  final ValueChanged<Widget> onPush;

  Professor({required this.onPush});

  @override
  _ProfessorState createState() => _ProfessorState();
}

class _ProfessorState extends State<Professor> {
  final Bloc bloc = Bloc();
  static List<String> days = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab"];
  final ScrollController _scrollController = ScrollController();
  bool loader = false;

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
                      snapshot.hasData ? snapshot.data!.nome! : "",
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
                      snapshot.hasData ? snapshot.data!.nome! : "",
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
                    navigatorKey.currentState!.pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
                  },
                  icon: Icon(
                    FeatherIcons.logOut,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget bodyCard(turma, size) {
    return Column(
      children: [
        Container(
          height: size.height * 0.12,
          margin: EdgeInsets.only(top: 2),
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days.map((days) {
              late Horario date;
              new DateFormat.yMMMd().format(new DateTime.now());
              bool hasDate = false;
              turma.horarios!.forEach((element) {
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
                        color: hasDate ? Color(0xff3D5AF1) : Color(0xff727272),
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
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          height: size.height * 0.055,
          width: size.width * 0.6,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xff28313b),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ManagerTurma(turma, bloc)),
              ).then((value) {
                setState(() {});
              })
            },
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
        ),
      ],
    );
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
                    itemCount: (snapshot.hasData && snapshot.data != null)
                        ? snapshot.data!.turmas!.length
                        : 0,
                    itemBuilder: (context, index) {
                      Turma turma = snapshot.data!.turmas![index];
                      return CardTurma(
                        turma: turma,
                        body: bodyCard(turma, size),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget buildOpenClass(Size size) {
    Function body = () {
      return StreamBuilder<List<Aula>>(
          stream: bloc.openClassList,
          builder: (context, AsyncSnapshot<List<Aula>> snapshot) {
            List<Aula> data = snapshot.data ?? [];
            return Container(
              width: size.width * 0.8,
              height: size.height * 0.27,
              child: Scrollbar(
                controller: _scrollController,
                radius: Radius.circular(8),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 0),
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
              color: Color(0xff0E153A),
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
      required String text,
      required double size,
      letterSpacing = -0.35,
      required FontWeight weight,
      required TextAlign align,
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
            builder: (context) =>
                FinishingClass(item, item.turma!, ClassBloc(bloc)),
          ),
        ).then((value) async {
          await bloc.fetchDataProf();
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: new BoxDecoration(
            color: Color(0xff3D5AF1), borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Hero(
              tag: "horario_class",
              child: Container(
                width: size.width * 0.23,
                child: genericText(
                    text: item.turma!.codigo!,
                    size: 18,
                    letterSpacing: -0.63,
                    weight: FontWeight.w600,
                    align: TextAlign.left),
              ),
            ),
            genericText(
                text: item.turma!.codigo!,
                size: 15,
                weight: FontWeight.w500,
                align: TextAlign.left),
            genericText(
                text: DateFormat("dd/MM HH:mm").format(item.horario!),
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
        onRefresh: () async => await bloc.fetchOpenClass(),
        child: FutureBuilder<dynamic>(
            future: bloc.fetchDataProf(),
            builder: (context, snapshot) {
              return Container(
                constraints: BoxConstraints.expand(),
                padding: EdgeInsets.only(left: 5, right: 5, top: 25),
                decoration: BoxDecoration(
                  color: Color(0xff0E153A),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      buildNameTitle(size),
                      Loader(
                        loader: (snapshot.connectionState ==
                                ConnectionState.done) ||
                            loader,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildOpenClass(size),
                              buildListTurmas(size),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
