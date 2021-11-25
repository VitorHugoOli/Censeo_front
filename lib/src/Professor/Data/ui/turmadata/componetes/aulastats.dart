import 'package:censeo/resources/constant.dart';
import 'package:censeo/src/Professor/Data/modal/turmastatsfull.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AulaStatsComponent extends StatelessWidget {
  final TurmaStatsFull turma;

  const AulaStatsComponent({Key? key, required this.turma}) : super(key: key);

  Widget buildProgress(title, int? subtotal, int? total,
      {Color valueColor = const Color(0xff539AA4)}) {
    int secureTotal = (total == 0||total == null) ? 1 : total;
    TextStyle style =
        GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: style),
            Text(
              "${subtotal ?? 0}/${total ?? 0} (${(((subtotal ?? 0) / (secureTotal)) * 100).toStringAsFixed(2)}%)",
              style: style,
            )
          ],
        ),
        SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            backgroundColor: Color(0xffC4C4C4),
            color: valueColor,
            minHeight: 10,
            value: (subtotal ?? 0) / (secureTotal),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detalhes das aulas",
            style: GoogleFonts.poppins(
              fontSize: 21,
              color: Censeo.dark_blue,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          buildProgress("Realizadas", turma.aulas?.done, turma.aulas?.total,
              valueColor: Censeo.vibrant_yellow),
          SizedBox(height: 10),
          buildProgress("Teórica", turma.aulas?.teorica, turma.aulas?.done),
          SizedBox(height: 10),
          buildProgress("Avaliativa", turma.aulas?.prova, turma.aulas?.done),
          SizedBox(height: 10),
          buildProgress("Trabalho", turma.aulas?.trabalho, turma.aulas?.done),
          SizedBox(height: 10),
          buildProgress("Expositiva", turma.aulas?.excursao, turma.aulas?.done),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
