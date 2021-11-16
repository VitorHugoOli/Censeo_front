import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManagerController {
  Map<String, TextEditingController> controllers =
      Map<String, TextEditingController>();

  TextEditingController managerControllers(label, {String initValue = ""}) {
    if (!controllers.containsKey(label)) {
      controllers.addAll({label: TextEditingController(text: initValue)});
    }
    return controllers[label]!;
  }

  void dispose() {
    for (TextEditingController i in controllers.values) {
      i.dispose();
    }
  }
}

class CustomTextField extends StatefulWidget {
  final ManagerController managerController;
  final String label;
  final String hintText;
  final TextInputType textInputType;
  final Function(String)? upDate;
  final double? width;
  final bool readOnly;
  final Color fillColors;
  final Color colorFont;
  final Color colorLabel;
  final bool pass;
  final int maxLines;

  final onTap;
  final TextAlign textAlign;
  final FormFieldValidator<String?>? validator;
  final String? initialValue;
  final Function(String)? onFieldSubmitted;
  final Color hintColor;
  final bool hasWidgetLabel;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  CustomTextField(
    this.managerController, {
    required this.label,
    this.hintText = "",
    this.textInputType = TextInputType.text,
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
    this.suffixIcon,
  });

  static InputDecoration formDecoration(
    String text, {
    fillColors = const Color(0x78ffffff),
    bool pass = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    hintColor = const Color(0x99ffffff),
  }) {
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
      suffixIcon: suffixIcon,
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

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassString = false;

  Widget automaticInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.label == "" || !widget.hasWidgetLabel
            ? Container()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: widget.colorLabel),
                  ),
                ],
              ),
        Container(
          width: widget.width,
          child: TextFormField(
            controller: widget.managerController.managerControllers(
                widget.label,
                initValue: widget.initialValue??""),
            onFieldSubmitted: widget.onFieldSubmitted == null
                ? (value) {}
                : widget.onFieldSubmitted,
            keyboardType: widget.textInputType,
            readOnly: widget.readOnly,
            onChanged: widget.upDate,
            maxLines: widget.maxLines,
            textAlign: widget.textAlign,
            onTap: widget.onTap,
            validator: widget.validator,
            obscureText: widget.pass,
            style: GoogleFonts.poppins(
              color: widget.colorFont,
              fontSize: 19,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.735,
            ),
            decoration: CustomTextField.formDecoration(widget.hintText,
                fillColors: widget.fillColors,
                pass: widget.pass,
                hintColor: widget.hintColor,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon),
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
