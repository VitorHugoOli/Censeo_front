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

class EditClassDialog extends StatefulWidget {
  final List<Horario> horarios;
  final int turmaId;
  final Bloc bloc;

  EditClassDialog(this.horarios, this.turmaId, this.bloc);

  static InputDecoration decoration(label, error) => InputDecoration(
        fillColor: Color(0xffe1e1e1),
        suffixIcon: error
            ? Container(
                margin: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                width: 35,
                height: 35,
                decoration: new BoxDecoration(borderRadius: BorderRadius.circular(50), color: Color(0xffffffff)),
                child: Center(
                  child: Text("!",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xffff3f85),
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.84,
                      )),
                ),
              )
            : null,
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
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Color(0xff898989),
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.735,
        ),
      );

  static Widget title() {
    return Text(
      "Horários de Aula",
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        color: Color(0xff7000ff),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static List<Widget> actions(context,int turmaId, size, Bloc bloc) {
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
                color: Color(0xff7E00DE),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(76),
                ),
                child: Text(
                  "Voltar",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.56,
                  ),
                ),
              ),
            ),
            StreamBuilder<List<ClassTime>>(
                stream: bloc.listSchedule,
                builder: (context, AsyncSnapshot<List<ClassTime>> snapshot) {
                  return Container(
                    width: size.width * 0.35,
                    height: size.height * 0.06,
                    child: RaisedButton(
                      color: Color(0xffff3f85),
                      onPressed: () async {
                        bloc.submitSchedule(turmaId, snapshot.data);
                        Navigator.of(context).pop();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(76),
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
                    ),
                  );
                }),
          ],
        ),
      ),
    ];
  }

  @override
  _EditClassDialogState createState() => _EditClassDialogState();
}

class _EditClassDialogState extends State<EditClassDialog> {
  final List<ClassTime> days = [
    ClassTime(Horario(dia: 'Segunda', sala: '')),
    ClassTime(Horario(dia: 'Terça', sala: '')),
    ClassTime(Horario(dia: 'Quarta', sala: '')),
    ClassTime(Horario(dia: 'Quinta', sala: '')),
    ClassTime(Horario(dia: 'Sexta', sala: '')),
    ClassTime(Horario(dia: 'Sabado', sala: '')),
  ];

  _validatorTime(value, index) {
    final reg = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');

    if (reg.hasMatch(value)) {
      setState(() {
        days[index].error = true;
//        messages = "Entre com um email valido.";
      });
      return "";
    } else {
      setState(() {
        days[index].error = false;
      });
      return null;
    }
  }

  @override
  void initState() {
    days.forEach((day) {
      for (Horario i in widget.horarios) {
        if (day.schedule.dia.substring(0, 3).toLowerCase() == i.dia.toLowerCase()) {
          day.controllerTime.text = DateFormat.Hm().format(i.horario);
          day.controllerRoom.text = i.sala;
          day.schedule.id = i.id;
        }
      }
    });
    widget.bloc.listScheduleChanged(days);
    super.initState();
  }

  @override
  void dispose() {
    days.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.6,
      child: SingleChildScrollView(
        child: Column(
          children: days.map((day) {
            return Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: size.height * 0.01, top: size.height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          day.schedule.dia,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        height: size.height * 0.08,
                        width: size.width * 0.33,
                        child: TextFormField(
                          controller: day.controllerTime,
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            MaskTextInputFormatter(
                                mask: '#@:&@',
                                filter: {"#": RegExp(r'[0-2]'), '@': RegExp(r'[0-9]'), '&': RegExp(r'[0-5]')})
                          ],
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            color: Color(0xff000000),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.735,
                          ),
                          decoration: EditClassDialog.decoration("Horário", day.error),
                          validator: (value) => _validatorTime(value, days.indexOf(day)),
                        ),
                      ),
                      Container(
                        height: size.height * 0.08,
                        width: size.width * 0.33,
                        child: TextFormField(
                          controller: day.controllerRoom,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            color: Color(0xff000000),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.735,
                          ),
                          decoration: EditClassDialog.decoration("Sala", day.error),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
