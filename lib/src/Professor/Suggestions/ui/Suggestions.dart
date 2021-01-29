import 'package:censeo/resources/loader.dart';
import 'package:censeo/src/Professor/Suggestions/models/Suggestion.dart';
import 'package:censeo/src/Professor/Suggestions/models/Topicos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../bloc/suggestions.dart';
import '../models/Categories.dart';
import 'EditSuggestionsDialog.dart';

class SuggestionPage extends StatefulWidget {
  SuggestionPage(this._categories, this.suggestionBloc) {
    suggestionBloc.fetchTopicos(_categories.id, _categories.tipo);
    suggestionBloc.fetchSuggestion(_categories.id, _categories.tipo);
  }

  final Categories _categories;
  final Bloc suggestionBloc;

  static InputDecoration decoration(hint) => InputDecoration(
        fillColor: Color(0x77ffffff),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: Color(0x88ffffff),
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

  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  String categories;

  Widget buildNameTitle(Size size) {
    return Column(
      children: [
        Container(
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Feather.arrow_left,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 40),
          child: Text(
            "Sugestões " + widget._categories.sigla,
            style: GoogleFonts.poppins(
              color: Color(0xffffffff),
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.77,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFilterCategories(Size size, context) {
    return Container(
      width: size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.7,
            height: size.height * 0.08,
            decoration: BoxDecoration(
              color: Color(0x77ffffff),
              borderRadius: BorderRadius.circular(32.0),
              border: Border.all(
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                  width: 0.80),
            ),
            child: StreamBuilder<List<Topicos>>(
                stream: widget.suggestionBloc.topicosList,
                builder: (context, snapshot) {
                  return DropdownButtonHideUnderline(
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: new DropdownButton<String>(
                          elevation: 0,
                          dropdownColor: Color(0xffBEA3EB),
                          value: categories,
                          onChanged: (value) {
                            setState(() {
                              categories = value;
                            });
                          },
                          hint: Text(
                            "Entre com o topico",
                            style: GoogleFonts.poppins(
                              color: Color(0x88ffffff),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.525,
                            ),
                          ),
                          icon: Icon(
                            FontAwesome.chevron_down,
                            color: Colors.white,
                          ),
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.white),
                          items: snapshot?.data
                              ?.map<DropdownMenuItem<String>>((Topicos value) {
                            return DropdownMenuItem<String>(
                              value: value.topico,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  value.topico,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.63,
                                  ),
                                ),
                              ),
                            );
                          })?.toList()),
                    ),
                  );
                }),
          ),
          ClipOval(
            child: Material(
              color: Color(0x77ffffff),
              elevation: 60, // button color
              child: InkWell(
                splashColor: Colors.transparent, // inkwell color
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(EvilIcons.pencil,
                        size: 45, color: Color(0xffffffff))),
                onTap: () {
                  EditSuggestion.dialog(context, widget.suggestionBloc,
                      widget._categories.id, widget._categories.tipo);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardSuggestion(Size size, Suggestion sug) {
    return Container(
      width: size.width * 0.8,
      height: size.height * 0.3,
      padding: EdgeInsets.all(16),
      decoration: new BoxDecoration(
          color: Color(0xffffffff), borderRadius: BorderRadius.circular(9)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  sug.titulo.toString(),
                  style: GoogleFonts.poppins(
                    color: Color(0xff22215b),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                Text(
                  "Dia " + DateFormat.Md('pt_BR').format(sug.data),
                  style: GoogleFonts.poppins(
                    color: Color(0xff22215b),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              sug.sugestao,
              style: GoogleFonts.poppins(
                color: Color(0xff6d6d6d),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.49,
              ),
            ),
          ),
          Container(
            width: size.width * 0.4,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      sug.relevancia = 0;
                      setState(() {});
                    },
                    icon: Icon(
                      FontAwesome.frown_o,
                      color: sug.relevancia == 0
                          ? Color(0xfffc0808)
                          : Color(0xff898989),
                      size: 35,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sug.relevancia = 1;
                      setState(() {});
                    },
                    icon: Icon(
                      FontAwesome.meh_o,
                      color: sug.relevancia == 1
                          ? Color(0xfffcb808)
                          : Color(0xff898989),
                      size: 35,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sug.relevancia = 2;
                      setState(() {});
                    },
                    icon: Icon(
                      FontAwesome.smile_o,
                      color: sug.relevancia == 2
                          ? Color(0xff36E37E)
                          : Color(0xff898989),
                      size: 35,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSuggestions(Size size) {
    return Container(
      width: size.width * 0.9,
      margin: EdgeInsets.only(top: 20),
      child: StreamBuilder<List<Suggestion>>(
        initialData: List<Suggestion>(),
        stream: widget.suggestionBloc.suggestionList,
        builder: (context, snapshot) {
          if (!snapshot.hasData || (snapshot?.data?.length == 0 ?? true)) {
            return Container(
              child: Lottie.asset('assets/empty.json'),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: snapshot?.data?.length ?? 0,
              itemBuilder: (context, index) {
                return buildCardSuggestion(size, snapshot.data[index]);
              },
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff7000FF), Color(0xFF5E06CE), Color(0xFF8F00FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.01, 0.4951],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Center(
            widthFactor: 1.5,
            child: Text(
              "Sugestões " + widget._categories.sigla,
              style: GoogleFonts.poppins(
                color: Color(0xffffffff),
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.77,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            return false;
          },
          child: Container(
            width: size.width,
            height: size.height - MediaQuery.of(context).padding.top,
            child: SingleChildScrollView(
              child: Loader(
                loader: true,
                child: Container(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
//                    Center(child: buildNameTitle(size)),
                      Center(child: buildFilterCategories(size, context)),
                      Center(child: buildSuggestions(size)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
