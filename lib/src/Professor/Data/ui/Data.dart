import 'package:censeo/resources/cardturma/cardTurma.dart';
import 'package:censeo/resources/charts/meanturma/meanturma.dart';
import 'package:censeo/resources/constant.dart';
import 'package:censeo/src/Professor/Data/bloc/bloc.dart';
import 'package:censeo/src/Professor/Data/modal/turmastats.dart';
import 'package:censeo/src/Professor/Data/ui/turmadata/turmadata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:collection/collection.dart';

class Data extends StatefulWidget {
  final ValueChanged<Widget> onPush;

  Data({required this.onPush});

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  final bloc = BlocData();

  @override
  void initState() {
    bloc.fetchTurmaStats();
    super.initState();
  }

  Column bodyCardTurma(TurmaStats turmaStats) {
    Map<String, double> first = {};
    Map<String, double> second = {};

    turmaStats.stats!.entries.forEachIndexed((index, element) =>
        (index < 5 ? first : second)[element.key] = element.value);

    Widget button = Censeo.button(
      text: "Ver Dados",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassData(turma: turmaStats.toTurma()),
          ),
        );
      },
    );

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
      backgroundColor: Censeo.dark_blue,
      appBar: AppBar(
        title: Text("Dados Professor"),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => bloc.fetchTurmaStats(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: StreamBuilder<List<TurmaStats>>(
              stream: bloc.turmasController.stream,
              initialData: [],
              builder: (context, snapshot) {
                List<TurmaStats> list = snapshot.data ?? [];

                return ListView.separated(
                    itemBuilder: (context, index) => CardTurma(
                          turma: list[index].toTurma(),
                          body: bodyCardTurma(list[index]),
                        ),
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemCount: list.length);
              }),
        ),
      ),
    );
  }
}
