import 'package:censeo/src/Aluno/Rank/bloc/rank.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class WeekEvaluation extends StatelessWidget {
  final BlocRank bloc;

  const WeekEvaluation({Key? key, required this.bloc}) : super(key: key);

  static const days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];

  static const iconsPath = {
    'fire': 'assets/strike_icons/fire.png',
    'cold_fire': 'assets/strike_icons/cold_fire.png',
    'snow': 'assets/strike_icons/snow.png',
    'cactus': 'assets/strike_icons/cactus.png'
  };

  Widget buildIcons(int indexDay, String iconLabel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 30,
          child: iconLabel == ''
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    width: 25,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Color(0xff383838),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                )
              : Image.asset(
                  iconsPath[iconLabel] ?? "",
                ),
        ),
        Text(
          days[indexDay],
          style: GoogleFonts.poppins(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Avaliações da Semana",
                    style: GoogleFonts.poppins(
                        color: Color(0xff0E153A),
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  Icon(
                    FontAwesomeIcons.questionCircle,
                    size: 0.8,
                    color: Color(0xff0E153A),
                  )
                ],
              ),
              SizedBox(height: 12),
              FutureBuilder<List<String>>(
                future: bloc.getStrikes(),
                initialData: List.filled(7, ''),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (i) => i)
                        .map((e) => buildIcons(e, snapshot.data![e]))
                        .toList(),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
