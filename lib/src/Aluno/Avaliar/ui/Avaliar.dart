import 'package:censeo/resources/Transformer.dart';
import 'package:censeo/resources/loader.dart';
import 'package:censeo/src/Aluno/Avaliar/bloc/aluno.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../main.dart';
import 'Perguntas.dart';

class Avaliar extends StatefulWidget {
  final ValueChanged<Widget> onPush;

  Avaliar({this.onPush});

  @override
  _AvaliarState createState() => _AvaliarState();
}

class _AvaliarState extends State<Avaliar> {
  final BlocAluno bloc = BlocAluno();
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
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.77,
                      ),
                    ),
                    Text(
                      "aluno",
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
                    navigatorKey.currentState.pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
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

  Widget buildCardAvatar(Size size) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.24,
      decoration: new BoxDecoration(
          color: Color(0xffffffff), borderRadius: BorderRadius.circular(9)),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  'assets/Avatar.png',
                  height: size.height * 0.15,
                ),
                Text(
                  "20.000",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xe2606060),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.63,
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            widthFactor: 7.5,
            child: IconButton(
              icon: Icon(Feather.settings),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  Widget buildRankProgress(Size size) {
    return Container(
        width: size.width * 0.9,
        height: size.height * 0.15,
        decoration: new BoxDecoration(
            color: Color(0xffffffff), borderRadius: BorderRadius.circular(9)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("DIAMANTE",
                style: GoogleFonts.poppins(
                  color: Color(0xff006dff),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.63,
                )),
            Container(
              width: size.width * 0.7,
              height: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  backgroundColor: Color(0xff006DFF),
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Color(0xff08B7FC)),
                  value: 0.8,
                ),
              ),
            ),
            Text(
              "8.000/20.000",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xe2606060),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.63,
              ),
            ),
          ],
        ));
  }

  Widget buildListTurmas(Size size) {
    return StreamBuilder(
        stream: bloc.classList,
        builder: (context, AsyncSnapshot<List<Aula>> snapshot) {
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
                        ? snapshot.data?.length ?? 0
                        : 0,
                    itemBuilder: (context, index) {
                      Aula turma = snapshot.data[index];
                      return buildCardTurmas(turma, size);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget buildCardTurmas(Aula aula, Size size) {
    Function title = () {
      return Container(
        height: size.height * 0.18,
        width: size.width * 0.15,
        padding: EdgeInsets.only(top: 20),
        margin: EdgeInsets.only(left: 20, right: 20),
        decoration: new BoxDecoration(
            color: Color(0xffff3f85), borderRadius: BorderRadius.circular(6)),
        child: Container(
          child: Text(
            aula.turma.disciplina.sigla.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Color(0xffffffff),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.56,
            ),
          ),
        ),
      );
    };

    Function body = (Size size) {
      return Container(
        width: size.width * 0.6,
        height: size.height * 0.10,
        // padding: EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              checkDisciplinaName(
                  aula.turma.codigo, aula.turma.disciplina.nome),
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xff242424),
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.63,
              ),
            ),
            Text(
              aula?.tema ?? "",
              style: GoogleFonts.poppins(
                color: Color(0xff4f4e4e),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.49,
              ),
            ),
          ],
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
          onPressed: () async {
            bool response = await bloc.createAvaliacao(aula.id);
            print(response);
            if (response) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Perguntas(bloc, aula),
                ),
              );
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "Avaliar",
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
      height: size.height * 0.2,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          title(),
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [body(size), button()],
            ),
          ),
        ],
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
        child: SingleChildScrollView(
          child: FutureBuilder<dynamic>(
              future: bloc.fetchOpenClass(),
              builder: (context, snapshot) {
                return Loader(
                  loader: (snapshot.connectionState == ConnectionState.done),
                  child: Container(
                    constraints: BoxConstraints(minHeight: size.height),
                    width: size.width,
                    padding: EdgeInsets.only(left: 5, right: 5, top: 25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff9e1a99), Color(0xffc01aba)],
                        stops: [0, 0.0989583358168602],
                        begin: Alignment(-1.00, 0.00),
                        end: Alignment(1.00, -0.00),
                        // angle: 0,
                        // scale: undefined,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        buildNameTitle(size),
                        SizedBox(
                          height: 20,
                        ),
                        buildCardAvatar(size),
                        SizedBox(
                          height: 10,
                        ),
                        // buildRankProgress(size),
                        SizedBox(
                          height: 10,
                        ),
                        buildListTurmas(size)
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
