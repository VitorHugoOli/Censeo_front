import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CustomTextField.dart';

class CustomDropDown<T> extends StatelessWidget {
  final Function(T) upDate;
  final Function(T) validator;
  final initValue;
  final String title;
  final List<T> items;
  final String Function(T value) valueSelect;

  CustomDropDown({this.upDate,
    this.validator,
    this.initValue,
    this.title,
    this.items = const [],
    this.valueSelect});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        child: new DropdownButtonFormField<T>(
            decoration: CustomTextField.formDecoration(
              title,
              fillColors: Color(0xffE1E1E1),
              hintColor: Color(0xff555555),
            ),
            elevation: 0,
            dropdownColor: Color(0xffC4C4C4),
            value: initValue,
            onChanged: upDate,
            validator: validator,
            icon: Container(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                FeatherIcons.chevronDown,
                color: Color(0xff6D6D6D),
              ),
            ),
            style: GoogleFonts.poppins(fontSize: 12, color: Color(0xff0E153A)),
            items: items.map((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    valueSelect != null ? valueSelect(value) : value.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Color(0xff0E153A),
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


