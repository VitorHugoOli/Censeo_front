import 'package:flutter/material.dart';

class RankAluno extends StatefulWidget {
  final ValueChanged<Widget> onPush;

  const RankAluno({Key key, this.onPush}) : super(key: key);

  @override
  _RankAlunoState createState() => _RankAlunoState();
}

class _RankAlunoState extends State<RankAluno> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E153A),
      appBar: AppBar(title: Text("Dados Aluno"),),
      body: Container(
        constraints: BoxConstraints.expand(),
      ),
    );
  }
}
