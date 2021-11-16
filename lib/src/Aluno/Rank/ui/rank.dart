import 'package:censeo/src/Aluno/Rank/bloc/rank.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RankAluno extends StatefulWidget {
  final ValueChanged<Widget> onPush;

  const RankAluno({Key? key, required this.onPush}) : super(key: key);

  @override
  _RankAlunoState createState() => _RankAlunoState();
}

class _RankAlunoState extends State<RankAluno> {
  var bloc = BlocRank();

  static const days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];

  static const iconsPath = {
    'fire': 'assets/strike_icons/fire.png',
    'cold_fire': 'assets/strike_icons/cold_fire.png',
    'snow': 'assets/strike_icons/snow.png',
    'cactus': 'assets/strike_icons/cactus.png'
  };

  Widget buildIcons(int indexDay, String iconLabel) {
    print(iconLabel);
    return Container(
      width: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (iconLabel != '')
            Image.asset(
              iconsPath[iconLabel] ?? "",
              scale: 2.5,
            ),
          if (iconLabel == '')
            Container(
              width: 24,
              height: 10,
              color: Colors.black54,
            ),
          Text(
            days[indexDay],
            style: GoogleFonts.poppins(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E153A),
      appBar: AppBar(
        title: Center(
            child: Text(
          "Rank",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        )),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xffE2F3F5),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Avaliações da Semana",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                        Icon(
                          FontAwesomeIcons.questionCircle,
                          size: 0.8,
                          color: Color(0xff0E153A),
                        )
                      ],
                    ),
                    FutureBuilder<List<String>>(
                      future: bloc.getStrikes(),
                      initialData: List.filled(7, ''),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        return Row(
                          children: List.generate(7, (i) => i)
                              .map((e) => buildIcons(e, snapshot.data![e]))
                              .toList(),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
