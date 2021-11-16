import 'package:censeo/src/Aluno/Suggestion/bloc/suggestions.dart';
import 'package:censeo/src/Professor/Suggestions/models/Categories.dart';
import 'package:censeo/src/Professor/Suggestions/models/Suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'Dialog.dart';

class SuggestionAluno extends StatefulWidget {
  final Bloc bloc;
  final Categories categories;

  SuggestionAluno(this.bloc, this.categories);

  @override
  _SuggestionALunoState createState() => _SuggestionALunoState();
}

class _SuggestionALunoState extends State<SuggestionAluno> {
  @override
  void initState() {
    super.initState();
    widget.bloc.fetchSuggestion(widget.categories.id, widget.categories.tipo!);
  }

  Widget buildNameTitle() {
    return Text(
      "Sugestões",
      style: GoogleFonts.poppins(
        color: Color(0xffffffff),
        fontSize: 25,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        letterSpacing: -0.77,
      ),
    );
  }

  Widget buildListSuggestions() {
    return Expanded(
      child: StreamBuilder<List<Suggestion>>(
        stream: widget.bloc.suggestionList,
        initialData: [],
        builder: (context, snapshot) {
          List<Suggestion> listSug = snapshot.data!;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: listSug.map((e) => buildCardSuggestion(e)).toList(),
            ),
          );
        },
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
              if (sug.data != null)
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
              sug.sugestao!,
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
              Icon(
                FeatherIcons.frown,
                color: sug.relevancia == 'baixa'
                    ? Color(0xfffc0808)
                    : Color(0xff0E153A),
                size: 35,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  FeatherIcons.meh,
                  color: sug.relevancia == 'media'
                      ? Color(0xfffcb808)
                      : Color(0xff0E153A),
                  size: 35,
                ),
              ),
              Icon(
                FeatherIcons.smile,
                color: sug.relevancia == 'alta'
                    ? Color(0xff36E37E)
                    : Color(0xff0E153A),
                size: 35,
              ),
            ],
          )
        ],
      ),
    );
  }

  buildButtonAdd() {
    return ClipOval(
      child: SizedBox(
        height: 50,
        width: 50,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Ink(
              decoration: const ShapeDecoration(
                color: Color(0xff189FD9),
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: Icon(FeatherIcons.plus),
                color: Colors.white,
                onPressed: () {
                  CreateSuggestion(widget.bloc, widget.categories)
                      .dialog(context)
                      .then(
                    (value) {
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E153A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildNameTitle(),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: buildButtonAdd(),
                    ),
                    buildListSuggestions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
