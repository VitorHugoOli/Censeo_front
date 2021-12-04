import 'package:censeo/resources/constant.dart';
import 'package:censeo/resources/loader.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:censeo/src/Professor/Data/bloc/classdata.dart';
import 'package:censeo/src/Professor/Data/modal/turmastatsfull.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'componetes/aulastats.dart';
import 'componetes/caracteristicasstats.dart';

class ClassData extends StatefulWidget {
  final Turma turma;

  const ClassData({Key? key, required this.turma}) : super(key: key);

  @override
  State<ClassData> createState() => _ClassDataState();
}

class _ClassDataState extends State<ClassData> {
  late BlocClassData bloc;
  bool loader = true;

  @override
  void initState() {
    bloc = BlocClassData(widget.turma);
    super.initState();
  }

  Widget get title => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.turma.codigo ?? "",
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
              Text(widget.turma.disciplina?.sigla ?? "",
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
          Container(
            width: 250,
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Text(
              widget.turma.disciplina?.nome ?? "",
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
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Censeo.dark_blue,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(child: title),
            SizedBox(height: 20),
            FutureBuilder<TurmaStatsFull?>(
              future: bloc.fetchTurmaStats(),
              initialData: TurmaStatsFull(),
              builder: (context, snapshot) =>Loader(
                loader: snapshot.connectionState == ConnectionState.done,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        AulaStatsComponent(
                            turma: snapshot.data ?? TurmaStatsFull()),
                        CaracteristicaStats(
                          turma: snapshot.data ?? TurmaStatsFull(),
                        ),
                        SizedBox(height: 20),
                        // Censeo.button(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) =>
                        //                   AulasList(turma: widget.turma)));
                        //     },
                        //     text: "Dados por aula",
                        //     color: Censeo.vibrant_blue,
                        //     padding:
                        //         EdgeInsets.symmetric(horizontal: 60, vertical: 8)),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
