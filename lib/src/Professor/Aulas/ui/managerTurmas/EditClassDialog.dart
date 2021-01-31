import 'package:censeo/resources/CustomTextField.dart';
import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xffffffff)),
                child: Center(
                  child: Text("!",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xff0E153A),
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
          borderRadius: BorderRadius.circular(8.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorText: null,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8.0),
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

  static Widget title(context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              "Horários de Aula",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xff0E153A),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.63,
              ),
            ),
          ),
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Feather.x,
                  color: Colors.black,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<Widget> actions(context, int turmaId, size, Bloc bloc) {
    return <Widget>[
      new Container(
        width: size.width * 0.8,
        height: size.height * 0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            StreamBuilder<List<ClassTime>>(
                stream: bloc.listSchedule,
                builder: (context, AsyncSnapshot<List<ClassTime>> snapshot) {
                  return Container(
                    width: size.width * 0.35,
                    height: size.height * 0.06,
                    child: RaisedButton(
                      color: Color(0xff0E153A),
                      onPressed: () async {
                        bloc.submitSchedule(turmaId, snapshot.data);
                        Navigator.of(context).pop();
                      },
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
        if (day.schedule.dia.substring(0, 3).toLowerCase() ==
            i.dia.toLowerCase()) {
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
    _body(Size size) {
      buildTopico(index) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width * 0.56,
                height: size.height * 0.08,
                child: TextFormField(
                  onChanged: (value) {},
                  initialValue: '',
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    color: Color(0xff555555),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.735,
                  ),
                  decoration:
                      CustomTextField.formDecoration("Digite a descrição"),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: Center(
                  child: Ink(
                    width: 40,
                    height: 40,
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      color: Colors.white,
                      icon: Icon(
                        FontAwesome.trash_o,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }

      return Container(
        height: size.height * 0.5,
        width: size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 0,
                minHeight: 0,
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.4,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemCount: 0,
                itemBuilder: (context, index) {
                  return buildTopico(index);
                },
              ),
            ),
            Material(
              color: Colors.white,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ink(
                      decoration: const BoxDecoration(
                        color: Color(0xff3D5AF1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          FlatButton(
                            onPressed: () {},
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Icon(
                                  Octicons.plus_small,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Container(
                                  width: size.width * 0.03,
                                ),
                                Text(
                                  'Adicionar Tópico',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.735,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.6,
      child: SingleChildScrollView(
        child: _body(size),
      ),
    );
  }
}
