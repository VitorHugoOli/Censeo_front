import 'package:censeo/resources/CustomTextField.dart';
import 'package:censeo/src/Aluno/Suggestion/bloc/suggestions.dart';
import 'package:censeo/src/Professor/Suggestions/models/Categories.dart';
import 'package:censeo/src/Professor/Suggestions/models/Suggestion.dart';
import 'package:censeo/src/Professor/Suggestions/models/Topicos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:google_fonts/google_fonts.dart';

class CreateSuggestion {
  ManagerController _controller = ManagerController();
  late String topico;
  final Bloc bloc;
  final Categories categories;
  late Suggestion _suggestion;
  final _formKey = GlobalKey<FormState>();

  CreateSuggestion(this.bloc, this.categories) {
    _suggestion = Suggestion(titulo: "", sugestao: "");
    bloc.fetchTopicos(categories.id, categories.tipo!);
  }

  static Widget _title(context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              "Editar Tópicos",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xff0E153A),
                fontSize: 21,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.63,
              ),
            ),
          ),
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: IconButton(
                  icon: Icon(FeatherIcons.x),
                  color: Color(0xff0E153A),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _actions(size, context) {
    return <Widget>[
      Container(
        width: double.maxFinite,
        child: Center(
          child: Column(
            children: [
              Container(
                width: size.width * 0.35,
                height: size.height * 0.05,
                child: RaisedButton(
                  color: Color(0xff0E153A),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      bloc.createSuggestion(
                          categories.id, _suggestion, categories.tipo!);
                      Navigator.pop(context);
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Pronto!",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.56,
                    ),
                  ),
                ),
              ),
              Container(
                height: size.height * 0.02,
              )
            ],
          ),
        ),
      ),
    ];
  }

  Future<dynamic> dialog(context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9))),
          title: _title(context),
          content: _body(size),
          actions: _actions(size, context),
        );
      },
    );
  }

  _body(Size size) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          width: double.maxFinite,
          child: StreamBuilder<List<Topicos>>(
            stream: bloc.topicosList,
            initialData: [],
            builder: (context, snapshot) {
              List<Topicos> list = snapshot.data ?? [];
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopicosDropDown(list, _suggestion),
                  if (list.length > 0)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: CustomTextField(
                        _controller,
                        label: "",
                        fillColors: Color(0xffE1E1E1),
                        colorFont: Color(0xff000000),
                        hintText: "Título",
                        validator: (value) =>
                            value!.isEmpty ? "Entre com algum título" : null,
                        hintColor: Color(0xff555555),
                        upDate: (value) {
                          _suggestion.titulo = value;
                        },
                      ),
                    ),
                  if (list.length > 0)
                    CustomTextField(
                      _controller,
                      label: "descricao",
                      validator: (value) =>
                          value!.isEmpty ? "Entre com alguma descrição" : null,
                      fillColors: Color(0xffE1E1E1),
                      colorFont: Color(0xff000000),
                      hintText: "Descrição",
                      hintColor: Color(0xff555555),
                      maxLines: 8,
                      upDate: (value) {
                        _suggestion.sugestao = value;
                      },
                    )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class TopicosDropDown extends StatefulWidget {
  final List<Topicos> topicos;
  final Suggestion sug;

  TopicosDropDown(this.topicos, this.sug);

  @override
  _TopicosDropDownState createState() => _TopicosDropDownState();
}

class _TopicosDropDownState extends State<TopicosDropDown> {
  Topicos? topico;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        child: widget.topicos.length > 0
            ? new DropdownButtonFormField<Topicos>(
                decoration: CustomTextField.formDecoration(
                  "Entre com o tópico",
                  fillColors: Color(0xffE1E1E1),
                  hintColor: Color(0xff555555),
                ),
                elevation: 0,
                dropdownColor: Color(0xffC4C4C4),
                value: topico,
                onChanged: (value) {
                  setState(() {
                    topico = value!;
                    widget.sug.topico = value.id;
                  });
                },
                validator: (value) =>
                    value == null ? "Entre com algum tópico" : null,
                icon: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    FeatherIcons.chevronDown,
                    color: Color(0xff6D6D6D),
                  ),
                ),
                style:
                    GoogleFonts.poppins(fontSize: 12, color: Color(0xff6D6D6D)),
                items: widget.topicos
                    .map<DropdownMenuItem<Topicos>>((Topicos value) {
                  return DropdownMenuItem<Topicos>(
                    value: value,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        value.topico ?? "",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Color(0xff555555),
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.35,
                        ),
                      ),
                    ),
                  );
                }).toList())
            : Center(
                child: Text("Não há topicos de discussão."),
              ),
      ),
    );
  }
}
