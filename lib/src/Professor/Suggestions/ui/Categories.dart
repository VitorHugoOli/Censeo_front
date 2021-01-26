import 'package:censeo/resources/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/suggestions.dart';
import '../models/Categories.dart';
import 'Suggestions.dart';

class CategoriesPage extends StatelessWidget {
  final Bloc suggestionBloc = Bloc();
  final ValueChanged<Widget> onPush;

  CategoriesPage({this.onPush});

  Widget buildNameTitle(Size size) {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Text(
        "Sugesões",
        style: GoogleFonts.poppins(
          color: Color(0xffffffff),
          fontSize: 25,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.77,
        ),
      ),
    );
  }

  Widget buildSubTitle(Size size, String subtitle) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 3.0,
              width: 120.0,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              color: Color(0xffffffff),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.77,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 3.0,
              width: 120.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardCategories(Size size, Categories categories,context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuggestionPage(categories,suggestionBloc),));
      },
      child: Container(
        height: size.height * 0.1,
        decoration: new BoxDecoration(
          color: Color(0xff22215b),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  categories.sigla,
                  style: GoogleFonts.poppins(
                    color: Color(0xffffffff),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.63,
                  ),
                ),
                categories.codigo != null
                    ? new Text(
                  categories.codigo,
                        style: GoogleFonts.poppins(
                          color: Color(0xffffffff),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.385,
                        ),
                      )
                    : Container(),
              ],
            ),
            Container(
              width: size.width * 0.55,
              child: Text(categories.nome,
                  style: GoogleFonts.poppins(
                    color: Color(0xffffffff),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.56,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCategories(Size size) {
    return StreamBuilder<Map<String, List<Categories>>>(
        stream: suggestionBloc.categoriesList,
        builder: (context, snapshot) {
          return Container(
            height: size.height * 0.7,
            width: size.width * 0.9,
            child: Loader(
              loader: snapshot.hasData,
              child: snapshot.hasData
                  ? Column(
                      children: snapshot.data
                          .map((key, value) {
                            final body =
                              Column(
                                children: [
                                  buildSubTitle(size, key),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 10,
                                      );
                                    },
                                    itemCount: value.length,
                                    itemBuilder: (context, index) {
                                      Categories obj = value[index];
                                      return buildCardCategories(size, obj,context);
                                    },
                                  )
                                ],
                              );

                            return MapEntry(key, body);
                          })
                          .values
                          .toList())
                  : Container(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          return false;
        },
        child: Container(
          width: size.width,
          height: size.height - MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff7000FF), Color(0xFF5E06CE), Color(0xFF8F00FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.01, 0.4951],
            ),
          ),
          child: SingleChildScrollView(
            child: Loader(
              loader: true,
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(child: buildNameTitle(size)),
                    Center(child: buildCategories(size)),
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
