import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  
  
  Widget buildDS(Size size, context) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                onPressed: null,
                child: Text(
                  'Dados Pessoais',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.525,
                  ),
                ),
              ),
              Icon(
                FeatherIcons.chevronRight,
                color: Colors.black,
              ),
            ],
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Divider(
                color: Color(0xffD0D0D0),
                height: 4,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                onPressed: null,
                child: Text('Trocar Senha',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.525,
                    )),
              ),
              Icon(
                FeatherIcons.chevronRight,
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAvatar(Size size, context) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Avatares',
              style: GoogleFonts.poppins(
                color: Color(0xff000000),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.77,
              )),

          ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xff0E153A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Configurações',
            style: GoogleFonts.poppins(
              color: Color(0xffffffff),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.77,
            )),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [buildDS(size, context),buildAvatar(size, context)],//
            )
          ],
        )),
      ),
    );
  }
}
