import 'package:censeo/resources/Transformer.dart';
import 'package:censeo/resources/loader.dart';
import 'package:censeo/src/Aluno/Avaliar/bloc/aluno.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../main.dart';
import 'Perguntas.dart';
import 'Settings.dart';

class Avaliar extends StatefulWidget {
  final ValueChanged<Widget>? onPush;

  Avaliar({required this.onPush});

  @override
  _AvaliarState createState() => _AvaliarState();
}

class _AvaliarState extends State<Avaliar> {
  final BlocAluno bloc = BlocAluno();
  static List<String> days = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab"];
  final ScrollController _scrollController = ScrollController();
  bool loader = false;

  @override
  void initState() {
    super.initState();
    // Add code after super
  }

  Widget buildNameTitle(snapshot) {
    return Stack(
      children: [
        Center(
          child: Column(
            children: <Widget>[
              Text(
                snapshot.hasData ? snapshot.data!.nome : "",
                style: GoogleFonts.poppins(
                  color: Color(0xffffffff),
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.35,
                ),
              ),
              Text(
                "Aluno",
                style: GoogleFonts.poppins(
                  color: Color(0xffffffff),
                  fontSize: 16,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  FeatherIcons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Settings(user: snapshot.data!, bloc: bloc),
                    ),
                  );
                },
              ),
              IconButton(
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
            ],
          ),
        )
      ],
    );
  }

  Widget buildCardAvatar(AsyncSnapshot<User> snapshot) {
    String? profile = snapshot.data != null ? snapshot.data!.perfilPhoto : "";
    return snapshot.connectionState == ConnectionState.done
        ? Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              shape: BoxShape.circle,
            ),
            child: profile != null
                ? Image.network(
                    profile,
                    height: 150,
                    errorBuilder: (BuildContext? context, Object? exception,
                        StackTrace? stackTrace) {
                      return Container(
                        height: 150,
                        child: Center(
                          child: Icon(FeatherIcons.cloudOff, size: 20),
                        ),
                      );
                    },
                    loadingBuilder: (BuildContext? context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  )
                : Image.asset(
                    'assets/Avatar.png',
                    height: 150,
                  ),
          )
        : Container();
  }

  Widget buildListTurmas(Size size) {
    return StreamBuilder(
        stream: bloc.classList,
        builder: (context, AsyncSnapshot<List<Aula>> snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    itemCount: (snapshot.hasData && snapshot.data! != null)
                        ? snapshot.data?.length ?? 0
                        : 0,
                    itemBuilder: (context, index) {
                      Aula turma = snapshot.data![index];
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
    Widget title() {
      return Container(
        width: 65,
        height: double.infinity,
        padding: EdgeInsets.only(top: 25),
        decoration: new BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          aula.turma!.disciplina!.sigla!.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Color(0xff3D5AF1),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            letterSpacing: -0.56,
          ),
        ),
      );
    }

    Widget body() {
      return Container(
        width: size.width * 0.62,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              checkDisciplinaName(
                  aula.turma!.codigo!, aula.turma!.disciplina!.nome!),
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xff0E153A),
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.35,
              ),
            ),
            Text(
              aula.tema ?? "",
              style: GoogleFonts.poppins(
                color: Color(0xff0E153A),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.35,
              ),
            ),
          ],
        ),
      );
    }

    Widget button() {
      return Container(
        margin: EdgeInsets.only(top: 15),
        height: size.height * 0.055,
        width: size.width * 0.6,
        child: RaisedButton(
          color: Color(0xff3D5AF1),
          onPressed: () async {
            setState(() {
              loader = true;
            });
            bool response = await bloc.createAvaliacao(aula.id);
            if (response) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Perguntas(bloc, aula),
                ),
              ).then((value) {
                if (value) {
                  bloc.fetchOpenClass();
                }
                setState(() {
                  loader = false;
                });
              });
            } else {
              setState(() {
                loader = false;
              });
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "Avaliar",
            style: GoogleFonts.poppins(
              color: Color(0xffffffff),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.35,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xffE2F3F5),
        borderRadius: BorderRadius.circular(9),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            title(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [body(), button()],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<dynamic>(
          future: bloc.fetchOpenClass(),
          builder: (context, snapshot) {
            return Loader(
              loader:
                  (snapshot.connectionState == ConnectionState.done) && !loader,
              child: RefreshIndicator(
                onRefresh: () async {
                  return await bloc.fetchOpenClass();
                },
                child: Container(
                  constraints: BoxConstraints.expand(),
                  width: size.width,
                  padding: EdgeInsets.only(left: 5, right: 5, top: 25),
                  color: Color(0xff0E153A),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        StreamBuilder<User>(
                            stream: bloc.user,
                            builder:
                                (context, AsyncSnapshot<User> snapshotUser) {
                              return Column(
                                children: [
                                  buildNameTitle(snapshotUser),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildCardAvatar(snapshotUser),
                                ],
                              );
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        buildListTurmas(size)
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
