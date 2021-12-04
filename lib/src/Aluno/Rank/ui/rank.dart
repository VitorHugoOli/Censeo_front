import 'package:censeo/resources/cardturma/cardTurma.dart';
import 'package:censeo/resources/charts/meanturma/meanturma.dart';
import 'package:censeo/resources/constant.dart';
import 'package:censeo/src/Aluno/Rank/bloc/rank.dart';
import 'package:censeo/src/Aluno/Rank/ui/components/weekEvalution.dart';
import 'package:censeo/src/Aluno/Rank/ui/turma/turma.dart';
import 'package:censeo/src/Professor/Data/modal/turmastats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import 'package:lottie/lottie.dart';

class RankAluno extends StatefulWidget {
  final ValueChanged<Widget> onPush;

  const RankAluno({Key? key, required this.onPush}) : super(key: key);

  @override
  _RankAlunoState createState() => _RankAlunoState();
}

class _RankAlunoState extends State<RankAluno> {
  var bloc = BlocRank();

  Widget buildTurmas() {
    return FutureBuilder<List<TurmaStats>>(
      future: bloc.fetchTurmaStats(),
      initialData: [],
      builder: (context, snapshot) {
        List<TurmaStats> list = snapshot.data ?? [];

        return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => CardTurma(
                  turma: list[index].toTurma(),
                  body: bodyCardTurma(list[index]),
                ),
            separatorBuilder: (_, __) => SizedBox(height: 10),
            itemCount: list.length);
      },
    );
  }

  Column bodyCardTurma(TurmaStats turmaStats) {
    Map<String, double> first = {};
    Map<String, double> second = {};

    turmaStats.stats!.entries.forEachIndexed((index, element) =>
        (index < 5 ? first : second)[element.key] = element.value);

    Widget button = Censeo.button(
        text: "Ver Dados",
        onPressed: () {
          Censeo.go(context, TurmaRank(turma: turmaStats.toTurma()));
        });

    return Column(
      children: (turmaStats.stats?.length ?? 0) > 0
          ? [
              SizedBox(height: 15),
              MeanTurma(stats: first),
              SizedBox(height: 20),
              MeanTurma(stats: second),
              SizedBox(height: 20),
              button
            ]
          : [
              Lottie.asset('assets/empty.json', height: 200),
              Text("Não há dados ainda"),
              SizedBox(height: 20),
              button
            ],
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
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WeekEvaluation(bloc: bloc),
              SizedBox(height: 15),
              Flexible(
                fit: FlexFit.loose,
                child: buildTurmas(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
