import 'package:censeo/resources/CustomTextField.dart';
import 'package:censeo/src/Aluno/Suggestion/bloc/suggestions.dart';
import 'package:censeo/src/Professor/Suggestions/models/Categories.dart';
import 'package:censeo/src/Professor/Suggestions/models/Topicos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateSuggestion {
  ManagerController _controller = ManagerController();
  final Bloc bloc;
  final Categories categories;

  static Widget _title(context) {
    return Row(
      children: [
        Text(
          "Editar Tópicos",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xff7000ff),
            fontSize: 21,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            letterSpacing: -0.63,
          ),
        ),
        Material(
          color: Colors.transparent,
          child: Center(
            child: IconButton(
              icon: Icon(Feather.x),
              color: Color(0xff7000ff),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  CreateSuggestion(this.bloc, this.categories);

  List<Widget> _actions(size, context) {
    return <Widget>[
      Container(
        width: double.maxFinite,
        child: Center(
          child: Container(
            width: size.width * 0.35,
            height: size.height * 0.05,
            child: RaisedButton(
              color: Color(0xffff3f85),
              onPressed: () {
                // bloc.submitTopicos(id, type);
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [],
    );
  }
}
