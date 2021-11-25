import 'package:censeo/resources/constant.dart';
import 'package:censeo/src/Aluno/Rank/bloc/turmarank.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:censeo/src/Professor/Data/modal/turmastatsfull.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TurmaRank extends StatefulWidget {
  final Turma turma;

  const TurmaRank({Key? key, required this.turma}) : super(key: key);

  @override
  State<TurmaRank> createState() => _TurmaRankState();
}

class _TurmaRankState extends State<TurmaRank> {
  late BlocTurmaRank bloc;
  late User? user;

  @override
  void initState() {
    bloc = BlocTurmaRank(widget.turma);
    User.getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E153A),
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Center(
              child: Text(
                "Rank - ${widget.turma.disciplina?.nome ?? ""}",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Color(0xffffffff),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.56,
                  height: 1,
                ),
              ),
            ),
            SizedBox(height: 20),
            Flexible(
              child: FutureBuilder<TurmaStatsFull?>(
                future: bloc.fetchTurmaStats(),
                builder: (BuildContext context,
                    AsyncSnapshot<TurmaStatsFull?> snapshot) {
                  return Column(
                    children: [
                      Flexible(child: buildRank(snapshot.data?.rank ?? [])),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 40)
          ],
        ),
      ),
    );
  }

  buildItemRak(Rank? item, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color:
            user != null && item != null && user!.id == (item.userU?.id ?? -1)
                ? Color(0x42403131)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 33,
                child: Text(
                  "$index°",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: index < 6 ? Colors.green : Color(0xff323232)),
                ),
              ),
              ClipRRect(
                child: Censeo.profileAvatar(item?.perfilPhoto, height: 40),
              ),
              SizedBox(width: 10),
              Text(
                "${item?.userU?.nome ?? ""}",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          Text(
            "${(item?.turmaXp?.toInt().toString() ?? "") + " xp"}",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget buildRank(List<Rank?> rank) {
    return Container(
      constraints: BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) => buildItemRak(rank[index], index),
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: rank.length),
    );
  }
}
