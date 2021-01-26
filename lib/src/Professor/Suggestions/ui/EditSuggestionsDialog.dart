import 'package:censeo/src/Professor/Suggestions/bloc/suggestions.dart';
import 'package:censeo/src/Professor/Suggestions/models/Topicos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class EditSuggestion {
  static InputDecoration decoration(hint) => InputDecoration(
        fillColor: Color(0xffe1e1e1),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: Color(0x88898989),
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.525,
        ),
        filled: true,
        errorStyle: TextStyle(height: 0),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(33.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(33.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(33.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(33.0),
        ),
        errorText: null,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(33.0),
        ),
      );

  static Widget _title(context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            alignment: Alignment.topRight,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Feather.x,
              color: Color(0xff7000ff),
              size: 20,
            ),
          ),
        ),
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
      ],
    );
  }

  static List<Widget> _actions(size, context, Bloc bloc, id, type) {
    return <Widget>[
      Container(
        width: size.width * 0.8,
        child: Center(
          child: Container(
            width: size.width * 0.35,
            height: size.height * 0.06,
            child: RaisedButton(
              color: Color(0xffff3f85),
              onPressed: () {
                bloc.submitTopicos(id, type);
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

  static dialog(context, Bloc bloc, id, type) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(9))),
          title: _title(context),
          content: _body(size, bloc, type),
          actions: _actions(size, context, bloc, id, type),
        );
      },
    );
  }

  static _body(Size size, Bloc bloc, String type) {
    buildTopico(Topicos topico, index, snapshot) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: size.width * 0.56,
              height: size.height * 0.08,
              child: TextFormField(
                onChanged: (value) {
                  bloc.changeTopicosValue(value, index);
                },
                initialValue: topico.topico,
                keyboardType: TextInputType.multiline,
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  color: Color(0xff555555),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.735,
                ),
                decoration: decoration("Digite a descrição"),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: Center(
                child: Ink(
                  width: 40,
                  height: 40,
                  decoration: const ShapeDecoration(
                    color: Color(0xffff4b56),
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    onPressed: () {
                      bloc.removeTopicosValue(index, topico.id, type);
                    },
                    color: Colors.white,
                    icon: Icon(FontAwesome.minus),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return Container(
      height: size.height * 0.5,
      width: size.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder(
            stream: bloc.topicosList,
            builder: (context, snapshot) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                  maxWidth: size.width * 0.8,
                  maxHeight: size.height * 0.4,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: snapshot?.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    Topicos obj = snapshot?.data[index];
                    return buildTopico(obj, index, snapshot);
                  },
                ),
              );
            },
          ),
          Material(
            color: Colors.white,
            child: Center(
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Color(0xffff3f85),
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  onPressed: () {
                    bloc.addTopicosValue();
                  },
                  color: Colors.white,
                  icon: Icon(FontAwesome.plus),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
