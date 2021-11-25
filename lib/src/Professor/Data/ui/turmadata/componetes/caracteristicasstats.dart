import 'package:censeo/resources/charts/meancaracteristica/meancaracteristica.dart';
import 'package:censeo/resources/constant.dart';
import 'package:censeo/src/Professor/Data/modal/turmastatsfull.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CaracteristicaStats extends StatelessWidget {
  final TurmaStatsFull turma;

  const CaracteristicaStats({Key? key, required this.turma}) : super(key: key);

  buildStatsText(title, double value) {
    TextStyle style =
        GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16);
    return Row(
      children: [
        Text(title, style: style),
        Text(value.toStringAsFixed(2), style: style),
      ],
    );
  }

  Widget buildCaracteristicaStatsCard(
      CaracteristicasStats? caracteristicasStats) {
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
            caracteristicasStats?.nome?.split('/')[0] ?? "",
            style: GoogleFonts.poppins(
              fontSize: 19,
              color: Censeo.dark_blue,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStatsText("Media: ", caracteristicasStats?.media ?? 0),
              buildStatsText("Desvio: ", caracteristicasStats?.desvio ?? 0),
              buildStatsText(
                  "Variancia: ", caracteristicasStats?.variancia ?? 0),
            ],
          ),
          MeanCaracteristica(
              stats: caracteristicasStats?.ultimasDezMedias ?? {})
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15),
        Center(
          child: Text(
            "Detalhes por características",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 21, color: Colors.white),
          ),
        ),
        SizedBox(height: 15),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: turma.listCaracteristicas.length,
          separatorBuilder: (context, index) => SizedBox(height: 20),
          itemBuilder: (context, index) =>
              buildCaracteristicaStatsCard(turma.listCaracteristicas[index]),
        ),
      ],
    );
  }
}
