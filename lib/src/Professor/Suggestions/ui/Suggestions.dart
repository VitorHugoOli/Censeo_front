import 'package:censeo/resources/loader.dart';
import 'package:censeo/src/Professor/Suggestions/models/Suggestion.dart';
import 'package:censeo/src/Professor/Suggestions/models/Topicos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../bloc/suggestions.dart';
import '../models/Categories.dart';
import 'EditSuggestionsDialog.dart';

class SuggestionPage extends StatefulWidget {
  SuggestionPage(this._categories, this.suggestionBloc) {
    suggestionBloc.fetchTopicos(_categories.id, _categories.tipo!);
    suggestionBloc.fetchSuggestion(_categories.id, _categories.tipo!);
  }

  final Categories _categories;
  final Bloc suggestionBloc;

  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  Topicos? topico;
  static final all_topicos = Topicos(id: -1, topico: "Todos");

  Widget buildNameTitle(Size size) {
    return Column(
      children: [
        Container(
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              FeatherIcons.arrowLeft,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 40),
          child: Text(
            "Sugestões " + widget._categories.sigla!,
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.75,
            height: size.height * 0.08,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              border: Border.all(
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                  width: 0.80),
            ),
            child: StreamBuilder<List<Topicos>>(
                stream: widget.suggestionBloc.topicosList,
                initialData: [],
                builder: (context, snapshot) {
                  List<Topicos> listTopicos = <Topicos>[];
                  if (snapshot.hasData) {
                    listTopicos = snapshot.data!.toList();
                    if (listTopicos.length > 0 && listTopicos.last.id != -1) {
                      listTopicos.add(all_topicos);
                    }
                  }
                  return DropdownButtonHideUnderline(
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: new DropdownButton<Topicos>(
                            elevation: 0,
                            dropdownColor: Color(0xffdddddd),
                            value: topico,
                            onChanged: (value) {
                              setState(() {
                                topico = value;
                              });
                            },
                            hint: Text(
                              "Tópico",
                              style: GoogleFonts.poppins(
                                color: Color(0xff0E153A),
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: -0.525,
                              ),
                            ),
                            icon: Icon(
                              FeatherIcons.chevronDown,
                              color: Color(0xff0E153A),
                            ),
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.white),
                            items: listTopicos.map<DropdownMenuItem<Topicos>>(
                                (Topicos value) {
                              return DropdownMenuItem<Topicos>(
                                value: value,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 220,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        value.topico ?? "",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: Color(0xff0E153A),
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: -0.63,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList()),
                      ),
                    ),
                  );
                }),
          ),
          Container(
            height: size.height * 0.08,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              border: Border.all(
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                  width: 0.80),
            ),
            child: Material(
              color: Colors.transparent,
              elevation: 60, // button color
              child: InkWell(
                splashColor: Colors.transparent, // inkwell color
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(FeatherIcons.edit2,
                        size: 25, color: Color(0xff0E153A))),
                onTap: () {
                  setState(() {
                    topico = null;
                  });
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

  Widget buildCardSuggestion(Suggestion sug) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: new BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                sug.titulo.toString(),
                style: GoogleFonts.poppins(
                  color: Color(0xff404040),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              Text(
                "Dia " + DateFormat('dd/MM').format(sug.data!),
                style: GoogleFonts.poppins(
                  color: Color(0xff404040),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              sug.sugestao ?? "",
              style: GoogleFonts.poppins(
                color: Color(0xff4F4E4E),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.49,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  widget.suggestionBloc.updateSuggestion(
                      widget._categories.id, widget._categories.tipo!, "baixa");
                },
                child: Icon(
                  FeatherIcons.frown,
                  color: sug.relevancia == 'baixa'
                      ? Color(0xfffc0808)
                      : Color(0xff0E153A),
                  size: 35,
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.suggestionBloc.updateSuggestion(
                      widget._categories.id, widget._categories.tipo!, "media");
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    FeatherIcons.meh,
                    color: sug.relevancia == 'media'
                        ? Color(0xfffcb808)
                        : Color(0xff0E153A),
                    size: 35,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.suggestionBloc.updateSuggestion(
                      widget._categories.id, widget._categories.tipo!, "alta");
                },
                child: Icon(
                  FeatherIcons.smile,
                  color: sug.relevancia == 'alta'
                      ? Color(0xff36E37E)
                      : Color(0xff0E153A),
                  size: 35,
                ),
              ),
            ],
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
        initialData: <Suggestion>[],
        stream: widget.suggestionBloc.suggestionList,
        builder: (context, snapshot) {
          List<Suggestion> suggestions = <Suggestion>[];
          if (snapshot.hasData) {
            suggestions = snapshot.data!;
            if (topico != null && topico!.id != -1) {
              suggestions = suggestions
                  .where((element) => element.topico == topico!.id)
                  .toList();
            }
          }

          if (suggestions.length == 0) {
            return Container(
              child:
                  Lottie.asset('assets/empty.json', height: size.height * 0.35),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return buildCardSuggestion(suggestions[index]);
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
        color: Color(0xff0E153A),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Center(
            widthFactor: 1.5,
            child: Text(
              "Sugestões " + widget._categories.sigla!,
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
            return widget.suggestionBloc.fetchSuggestion(
                widget._categories.id, widget._categories.tipo!);
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
