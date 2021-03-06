import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class ManagerController {
  Map<String, TextEditingController> controllers =
      Map<String, TextEditingController>();

  TextEditingController managerControllers(label, {String initValue = ""}) {
    if (!controllers.containsKey(label)) {
      controllers.addAll({label: TextEditingController(text: initValue)});
    }
    return controllers[label];
  }

  void dispose() {
    for (TextEditingController i in controllers.values) {
      i.dispose();
    }
  }
}

class CustomTextField extends StatelessWidget {
  final ManagerController managerController;
  @required
  final String label;
  @required
  final String hintText;
  @required
  final TextInputType textInputType;
  @required
  final Function(String) upDate;
  final double width;
  final bool readOnly;
  final Color fillColors;
  final Color colorFont;
  final Color colorLabel;
  final bool pass;
  final int maxLines;

  final onTap;
  final TextAlign textAlign;
  final FormFieldValidator<String> validator;
  final String initialValue;
  final Function(String) onFieldSubmitted;
  final Color hintColor;
  final bool hasWidgetLabel;
  Icon prefixIcon;

  CustomTextField(
    this.managerController, {
    this.label,
    this.hintText,
    this.textInputType,
    this.upDate,
    this.width,
    this.readOnly = false,
    this.fillColors = const Color(0x78ffffff),
    this.colorFont = Colors.white,
    this.colorLabel = const Color(0xffffffff),
    this.pass = false,
    this.maxLines = 1,
    this.onTap,
    this.textAlign = TextAlign.left,
    this.validator,
    this.initialValue = "",
    this.onFieldSubmitted,
    this.hintColor = const Color(0x99ffffff),
    this.hasWidgetLabel = false,
    this.prefixIcon,
  });
  bool showPassString = false;

  static InputDecoration formDecoration(String text,
      {fillColors = const Color(0x78ffffff),
      bool pass = false,
      Icon prefixIcon,
      hintColor = const Color(0x99ffffff)}) {
    return InputDecoration(
      fillColor: fillColors,
      filled: true,
      hintText: text,
      hintStyle: GoogleFonts.poppins(
        color: hintColor,
        fontSize: 17,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        letterSpacing: -0.525,
      ),
      prefixIcon: prefixIcon,
      // suffixIcon: pass ?? false
      //     ? GestureDetector(
      //         onTap: () {
      //         },
      //         child: Icon(
      //           FeatherIcons.eye,
      //           color: Color(0xffB0B0B0),
      //         ),
      //       )
      //     : null,
      contentPadding: EdgeInsets.only(top: 0, left: 20),
      errorStyle: GoogleFonts.poppins(
          color: Color(0xffDB5555),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.525,
          height: 1),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(6.0),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(6.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(6.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(6.0),
      ),
      disabledBorder: InputBorder.none,
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }

  Widget automaticInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        label == "" || !hasWidgetLabel
            ? Container()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colorLabel),
                  ),
                ],
              ),
        Container(
          width: width,
          child: TextFormField(
            controller: managerController.managerControllers(label,
                initValue: initialValue),
            onFieldSubmitted:
                onFieldSubmitted == null ? (value) {} : onFieldSubmitted,
            keyboardType: TextInputType.text,
            readOnly: readOnly,
            onChanged: upDate,
            maxLines: maxLines,
            textAlign: textAlign,
            onTap: onTap,
            validator: validator,
            obscureText: pass,
            style: GoogleFonts.poppins(
              color: colorFont,
              fontSize: 19,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.735,
            ),
            decoration: formDecoration(hintText,
                fillColors: fillColors,
                pass: pass,
                hintColor: hintColor,
                prefixIcon: prefixIcon),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return automaticInput();
  }
}
