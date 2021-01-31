import 'package:censeo/resources/CustomTextField.dart';
import 'package:censeo/src/Aluno/Suggestion/bloc/suggestions.dart';
import 'package:censeo/src/Professor/Suggestions/models/Categories.dart';
import 'package:censeo/src/Professor/Suggestions/models/Suggestion.dart';
import 'package:censeo/src/Professor/Suggestions/models/Topicos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateSuggestion {
  ManagerController _controller = ManagerController();
  String topico;
  final Bloc bloc;
  final Categories categories;
  Suggestion _suggestion;

  CreateSuggestion(this.bloc, this.categories) {
    _suggestion = Suggestion();
    bloc.fetchTopicos(categories.id, categories.tipo);
  }

  static Widget _title(context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Center(
              child: Text(
                "Editar Tópicos",
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
          ),
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: IconButton(
                  icon: Icon(Feather.x),
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
                    // bloc.submitTopicos(id, type);
                    print(_suggestion.toJson());
                    Navigator.pop(context);
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
              Container(height: size.height * 0.02,)
            ],
          ),
        ),
      ),
    ];
  }

  dialog(context) {
    return showDialog(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Color(0xffE1E1E1),
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                  width: 0.80),
            ),
            child: StreamBuilder<List<Topicos>>(
              stream: bloc.topicosList,
              builder: (context, snapshot) {
                return TopicosDropDown(snapshot.data, _suggestion);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: CustomTextField(
              _controller,
              label: "",
              fillColors: Color(0xffE1E1E1),
              hintText: "Título",
              upDate: (value) {
                _suggestion.titulo = value;
              },
            ),
          ),
          CustomTextField(
            _controller,
            label: "",
            fillColors: Color(0xffE1E1E1),
            hintText: "Descrição",
            maxLines: 8,
            upDate: (value) {
              _suggestion.titulo = value;
            },

          )
        ],
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
  Topicos topico;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: new DropdownButton<Topicos>(
            elevation: 0,
            dropdownColor: Color(0xffE1E1ff),
            value: topico,
            onChanged: (value) {
              setState(() {
                topico = value;
                widget.sug.topicoId = value.id;
              });
            },
            hint: Text(
              "Entre com o topico",
              style: GoogleFonts.poppins(
                color: Color(0xff6D6D6D),
                fontSize: 17,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.525,
              ),
            ),
            icon: Icon(
              FeatherIcons.chevronDown,
              color: Color(0xff6D6D6D),
            ),
            style: GoogleFonts.poppins(fontSize: 12, color: Color(0xff6D6D6D)),
            items:
                widget.topicos?.map<DropdownMenuItem<Topicos>>((Topicos value) {
              return DropdownMenuItem<Topicos>(
                value: value,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    value.topico,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Color(0xff6D6D6D),
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.35,
                    ),
                  ),
                ),
              );
            })?.toList()),
      ),
    );
  }
}
