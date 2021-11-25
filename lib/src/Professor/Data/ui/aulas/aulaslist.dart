import 'package:censeo/resources/constant.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:censeo/src/Professor/Data/bloc/aulalist.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AulasList extends StatefulWidget {
  final Turma turma;

  const AulasList({Key? key, required this.turma}) : super(key: key);

  @override
  State<AulasList> createState() => _AulasListState();
}

class _AulasListState extends State<AulasList> {
  late BlocAulaList bloc;

  @override
  void initState() {
    bloc = BlocAulaList(widget.turma);
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

  Widget buildAulasCard(Aula aula) {
    return GestureDetector(
      onTap: (){
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ,));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dia ${aula.horario == null ? "" : DateFormat("dd/MM").format(aula.horario!)}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 22),
                ),
                Row(            crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Censeo.colorTypeClass[aula.tipoAula!],
                      ),
                      height: 12,
                      width: 12,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "${aula.tipoAula!}",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${aula.tema!}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 16,color:Color(0xff4F4E4E)),
                ),
                Icon(FontAwesomeIcons.chevronRight, color: Censeo.dark_blue)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildAulas(List<Aula?> aulas) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: aulas.length,
      separatorBuilder: (context, index) => SizedBox(height: 20),
      itemBuilder: (context, index) => buildAulasCard(aulas[index] ?? Aula()),
    );
  }

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
            FutureBuilder<List<Aula?>>(
              future: bloc.fetchTurmaStats(),
              initialData: [],
              builder: (context, snapshot) => Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [buildAulas(snapshot.data ?? [])],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
