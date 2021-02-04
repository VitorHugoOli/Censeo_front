import 'dart:ffi';

import 'package:censeo/resources/CustomTextField.dart';
import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SchedulerClass {
  String dia;
  TimeOfDay time;
  String Sala;
  bool isAssincrona;
}

class EditClassDialog extends StatefulWidget {
  final List<Horario> horarios;
  final int turmaId;
  final Bloc bloc;

  EditClassDialog(this.horarios, this.turmaId, this.bloc);

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
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.36,
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
      Container(
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<List<SchedulerClass>>(
                stream: bloc.listSchedule,
                builder:
                    (context, AsyncSnapshot<List<SchedulerClass>> snapshot) {
                  return Container(
                    width: size.width * 0.45,
                    height: size.height * 0.06,
                    child: RaisedButton(
                      color: Color(0xff0E153A),
                      onPressed: () async {
                        bloc.submitSchedule(turmaId, snapshot.data);
                        // Navigator.of(context).pop();
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
  ManagerController _controller = ManagerController();

  String _validatorTime(String value) {
    final reg = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');

    if (reg.hasMatch(value)) {
      setState(() {
        // days[index].error = true;
//        messages = "Entre com um email valido.";
      });
      return "";
    } else {
      setState(() {
        // days[index].error = false;
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTopico(SchedulerClass aula, index, size) {
      return Container(
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              children: [
                SchedulerDropDown(aula),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Future<TimeOfDay> selectedTime24Hour = showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(hour: 10, minute: 47),
                          builder: (BuildContext context, Widget child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child,
                            );
                          },
                        );
                        // _controller.controllers['"Horario" + index.toString()']
                        //     .text = selectedTime24Hour.toString();
                        // aula.time = selectedTime24Hour;
                        },
                      child: CustomTextField(
                        _controller,
                        label: "Horario" + index.toString(),
                        validator: _validatorTime,
                        fillColors: Color(0xffE1E1E1),
                        hintColor: Color(0xff555555),
                        readOnly: true,
                        colorFont: Theme.of(context).colorScheme.primary,
                        width: 100,
                      ),
                    ),
                    CustomTextField(
                      _controller,
                      label: "Sala" + index.toString(),
                      upDate: (value) {
                        aula.Sala = value;
                      },
                      fillColors: Color(0xffE1E1E1),
                      hintColor: Color(0xff555555),
                      colorFont: Theme.of(context).colorScheme.primary,
                      width: 100,
                    )
                  ],
                )
              ],
            )),
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
                    onPressed: () {
                      widget.bloc.removeSchedule(index);
                    },
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

    Widget _body(Size size) {
      return Container(
        height: size.height * 0.5,
        width: double.maxFinite,
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
              child: StreamBuilder<List<SchedulerClass>>(
                  stream: widget.bloc.listSchedule,
                  builder: (context, snapshot) {
                    List<SchedulerClass> listClass = List<SchedulerClass>();
                    if (snapshot.hasData && snapshot.data != null) {
                      listClass = snapshot.data;
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: listClass.length,
                      itemBuilder: (context, index) {
                        return buildTopico(listClass[index], index, size);
                      },
                    );
                  }),
            ),
            Material(
              color: Colors.white,
              child: Ink(
                decoration: const BoxDecoration(
                  color: Color(0xff3D5AF1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    FlatButton(
                      onPressed: () {
                        widget.bloc.addSchedule();
                        setState(() {});
                      },
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Icon(
                            Octicons.plus_small,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Adicionar Novo Horario',
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
            ),
          ],
        ),
      );
    }

    Size size = MediaQuery.of(context).size;
    return Container(
      child: SingleChildScrollView(
        child: _body(size),
      ),
    );
  }
}

class SchedulerDropDown extends StatefulWidget {
  final SchedulerClass schClass;

  SchedulerDropDown(this.schClass);

  @override
  _SchedulerDropDownState createState() => _SchedulerDropDownState();
}

class _SchedulerDropDownState extends State<SchedulerDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        child: new DropdownButtonFormField<String>(
            decoration: CustomTextField.formDecoration(
              "Entre com o tópico",
              fillColors: Color(0xffE1E1E1),
              hintColor: Color(0xff555555),
            ),
            elevation: 0,
            dropdownColor: Color(0xffC4C4C4),
            value: null,
            onChanged: (value) {
              setState(() {
                widget.schClass.dia = value;
              });
            },
            validator: (value) =>
                value == null ? "Entre com algum tópico" : null,
            icon: Container(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                FeatherIcons.chevronDown,
                color: Color(0xff6D6D6D),
              ),
            ),
            style: GoogleFonts.poppins(fontSize: 12, color: Color(0xff6D6D6D)),
            items: ['SEG', 'ter'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Color(0xff555555),
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
