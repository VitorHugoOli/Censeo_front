import 'dart:ui';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class Censeo {
  static const Map<String, String> abreveation = {
    "utilidade": "up",
    "percepcao": "pfu",
    "prazer": "pp",
    "concentracao/": "con",
    "qualidade": "qc",
    "aprendizagem": "ap",
    "organizacao": "org",
    "interacao": "int.g",
    "amplitude": "amp",
    "tarefas/exames": "ta/ex"
  };

  static String? findAbreveation(String word) {
    var newWord = removeDiacritics(word.toLowerCase());
    return abreveation[newWord.split(' ')[0]];
  }

  static const vibrant_blue = Color(0xff3D5AF1);
  static const vibrant_yellow = Color(0xffF8B83C);
  static const vibrant_purple = Color(0xff7000FF);
  static const light_blue = Color(0xffE2F3F5);
  static const dark_blue = Color(0xff0E153A);

  static ElevatedButton button(
      {required VoidCallback? onPressed,
      required String text,
      EdgeInsetsGeometry? padding,
      Color color = const Color(0xff28313b)}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 50, vertical: 8),
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Color(0xffffffff),
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.63,
        ),
      ),
    );
  }

  static const Map colorTypeClass = {
    null: Colors.grey,
    'teorica': Colors.amber,
    'prova': Colors.blue,
    'trabalho': Colors.red,
    'excursao': Colors.green,
  };

  static go(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  static Image profileAvatar(String? profile,{double height = 150}) {
    if (profile != null) {
      return Image.network(
        profile,
        height: height,
        errorBuilder: (BuildContext? context, Object? exception,
            StackTrace? stackTrace) {
          return Container(
            height: height,
            child: Center(
              child: Icon(FeatherIcons.cloudOff, size: 20),
            ),
          );
        },
        loadingBuilder: (BuildContext? context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    } else {
      return Image.asset(
        'assets/Avatar.png',
        height: height,
      );
    }
  }

}
