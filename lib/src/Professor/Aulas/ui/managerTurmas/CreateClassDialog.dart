import 'package:censeo/resources/CustomTextField.dart';
import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ClassTime {
  Horario schedule;
  TextEditingController controllerTime = TextEditingController();
  TextEditingController controllerRoom = TextEditingController();
  bool error = false;

  ClassTime(this.schedule);
}

class CreateClassDialog extends StatefulWidget {
  final DateTime date;
  final Bloc bloc;

  CreateClassDialog(this.date, this.bloc);

  static Widget title() {
    return Text(
      "Criar Aula",
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        color: Color(0xff0E153A),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static List<Widget> actions(context, size, DateTime date, Bloc bloc, int id) {
    return <Widget>[
      new Container(
        width: size.width * 0.8,
        height: size.height * 0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: size.width * 0.35,
              height: size.height * 0.06,
              child: RaisedButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Voltar",
                  style: GoogleFonts.poppins(
                    color: Color(0xff0E153A),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.56,
                  ),
                ),
              ),
            ),
            Container(
              width: size.width * 0.35,
              height: size.height * 0.06,
              child: StreamBuilder<bool>(
                  stream: bloc.submitCheck,
                  builder: (context, snapshot) {
                    return RaisedButton(
                      color: Color(0xff3D5AF1),
                      onPressed: (snapshot.hasData && snapshot.data)
                          ? () async {
                              bloc.submitCreateClass(id, date);
                              Navigator.of(context).pop();
                            }
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Confirmar",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.56,
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    ];
  }

  @override
  _CreateClassDialogState createState() => _CreateClassDialogState();
}

class _CreateClassDialogState extends State<CreateClassDialog> {
  TextEditingController controllerTime = TextEditingController();
  TextEditingController controllerRoom = TextEditingController();
  bool timeError = false;
  bool roomError = false;
  String messages = "";

  _validatorTime(value) {
    final reg = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');

    if (reg.hasMatch(value)) {
      setState(() {
        timeError = true;
        messages = "Entre com um Horario valido.";
      });
      return "";
    } else {
      setState(() {
        roomError = false;
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.18,
      child: Column(
        children: [
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 3),
                  width: size.width * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.EEEE('pt_BR').format(widget.date),
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Color(0xff0E153A),fontSize: 31),
                      ),
                      Text(
                        DateFormat.Md('pt_BR').format(widget.date),
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Color(0xff0E153A), fontSize: 31),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        height: size.height * 0.08,
                        width: size.width * 0.315,
                        child: TextFormField(
                          onChanged: widget.bloc.horarioChanged,
                          controller: controllerTime,
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            MaskTextInputFormatter(mask: '#@:&@', filter: {
                              "#": RegExp(r'[0-2]'),
                              '@': RegExp(r'[0-9]'),
                              '&': RegExp(r'[0-5]')
                            })
                          ],
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            color: Color(0xff000000),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.735,
                          ),
                          decoration: CustomTextField.formDecoration("Horário",
                              fillColors: Color(0x78c2c2c2),
                              hintColor: Color(0xff696969)),
                          validator: (value) => _validatorTime(value),
                        )),
                    Container(
                      height: size.height * 0.08,
                      width: size.width * 0.315,
                      child: TextFormField(
                        onChanged: widget.bloc.roomChanged,
                        controller: controllerRoom,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          color: Color(0xff000000),
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.735,
                        ),
                        decoration: CustomTextField.formDecoration("Sala",
                            fillColors: Color(0x78c2c2c2),
                            hintColor: Color(0xff696969)),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

