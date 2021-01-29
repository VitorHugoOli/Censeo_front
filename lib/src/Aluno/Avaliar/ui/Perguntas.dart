import 'package:censeo/resources/loader.dart';
import 'package:censeo/src/Aluno/Avaliar/bloc/aluno.dart';
import 'package:censeo/src/Aluno/Avaliar/models/Avaliacao.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class Perguntas extends StatefulWidget {
  final Aula _aula;
  final BlocAluno _blocAluno;

  Perguntas(this._blocAluno, this._aula);

  static InputDecoration decoration() => InputDecoration(
        fillColor: Color(0x96ffffff),
        filled: true,
        hintText: "Digite sua experiencia",
        hintStyle: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(18.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(18.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(18.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(18.0),
        ),
        errorText: null,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(33.0),
        ),
      );

  @override
  _PerguntasState createState() => _PerguntasState();
}

class _PerguntasState extends State<Perguntas> {
  final TextEditingController _abertaController =
      TextEditingController(text: "");
  int currentIndex = 0;

  Widget buildNameTitle(Size size) {
    return Column(
      children: [
        Center(
          child: Column(
            children: <Widget>[
              Text(
                widget._aula.turma.disciplina.sigla,
                style: GoogleFonts.poppins(
                  color: Color(0xffffffff),
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
              ),
              Text(
                widget._aula.tema ?? "",
                style: GoogleFonts.poppins(
                  color: Color(0xffffffff),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.49,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCardQuestion(Avaliacao avaliacao, Size size) {
    Function title = () {
      return Text(avaliacao.perguntas[currentIndex].caracteristica,
          style: GoogleFonts.poppins(
            color: Color(0xff22215b),
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ));
    };

    Function body = (Size size) {
      return Text(
        avaliacao.perguntas[currentIndex].questao,
        style: GoogleFonts.poppins(
          color: Color(0xff6d6d6d),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      );
    };

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      constraints: BoxConstraints(minHeight: size.height * 0.20),
      width: size.width * 0.9,
      padding: EdgeInsets.only(left: 12, right: 12),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          title(),
          body(size),
        ],
      ),
    );
  }

  final List qualificativas = [
    {
      'label': "Perfeita",
      'icon': Icon(
        FontAwesome5.laugh,
        size: 28,
      )
    },
    {
      'label': "Boa",
      'icon': Icon(
        FontAwesome5.grin,
        size: 28,
      )
    },
    {
      'label': "Regular",
      'icon': Icon(
        FontAwesome5.meh,
        size: 28,
      )
    },
    {
      'label': "Ruim",
      'icon': Icon(
        FontAwesome5.frown,
        size: 28,
      )
    },
    {
      'label': "Pessima",
      'icon': Icon(
        FontAwesome5.angry,
        size: 28,
      )
    }
  ];

  Widget frameButton(
      {@required Size size,
      @required Widget child,
      @required width,
      @required Function onClick}) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: width,
        height: size.height * 0.08,
        padding: EdgeInsets.only(left: 12, right: 12),
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(9),
        ),
        child: child,
      ),
    );
  }

  submitResposta(Avaliacao aval, resp, tipo) {
    if (currentIndex < aval.perguntas.length - 1) {
      widget._blocAluno.submitAvaliacao(
          aval.id, aval.perguntas[currentIndex].id, resp, tipo);
      setState(() {
        currentIndex++;
      });
    } else {
      widget._blocAluno.submitAvaliacao(
          aval.id, aval.perguntas[currentIndex].id, resp, tipo,
          end: true);
      Navigator.pop(context);
    }
  }

  Widget buildAnswer(Avaliacao avaliacao, Size size) {
    switch (avaliacao.perguntas[currentIndex].tipoQuestao) {
      case 'aberta':
        return Column(
          children: [
            Container(
              width: size.width * 0.9,
              height: size.height * 0.3,
              child: TextField(
                controller: _abertaController,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.left,
                maxLines: 5,
                style: GoogleFonts.poppins(
                  color: Color(0xffffffff),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.735,
                ),
                decoration: Perguntas.decoration(),
              ),
            ),
            buildButton(avaliacao, size)
          ],
        );
      case 'qualificativa':
        return Column(
          children: qualificativas.map((value) {
            return frameButton(
              onClick: () {
                submitResposta(
                    avaliacao, value['label'].toLowerCase(), 'qualificativa');
              },
              size: size,
              width: size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  value['icon'],
                  Container(
                    width: size.width * 0.7,
                    child: Text(
                      value['label'],
                      style: GoogleFonts.poppins(
                        color: Color(0xff494949),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        );
      case 'binario':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: ['Sim', 'Não'].map((e) {
            return frameButton(
              onClick: () {
                submitResposta(avaliacao, ('Sim' == e), 'binario');
              },
              size: size,
              width: size.width * 0.4,
              child: Center(
                child: Text(
                  e,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Color(0xff494949),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        );

      default:
        return Container();
    }
  }

  buildButton(Avaliacao avaliacao, Size size) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: size.height * 0.07,
      width: size.width * 0.8,
      child: RaisedButton(
        color: Color(0xff28313b),
        onPressed: () async {
          submitResposta(avaliacao, _abertaController.text, 'aberta');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          "Responder",
          style: GoogleFonts.poppins(
            color: Color(0xffffffff),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            letterSpacing: -0.63,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xff0E153A),
        body: StreamBuilder<Avaliacao>(
            stream: widget._blocAluno.avalList,
            builder: (context, snapshot) {
              Avaliacao avaliacao = snapshot.data;
              if (snapshot.hasData && avaliacao.perguntas.length > 0) {
                return Container(
                  constraints: BoxConstraints(minHeight: size.height),
                  width: size.width,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(left: 5, right: 5, top: 20),
                      margin: EdgeInsets.only(bottom: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          buildNameTitle(size),
                          SizedBox(
                            height: 10,
                          ),
                          buildCardQuestion(avaliacao, size),
                          buildAnswer(avaliacao, size),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Loader(
                  loader: true,
                  child: Container(),
                );
              }
            }));
  }
}
