import 'package:censeo/resources/CustomDropDown.dart';
import 'package:censeo/resources/CustomTextField.dart';
import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
                  FeatherIcons.x,
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
            StreamBuilder<List<Horario>>(
                stream: bloc.listSchedule,
                builder: (context, AsyncSnapshot<List<Horario>> snapshot) {
                  return Container(
                    width: size.width * 0.45,
                    height: size.height * 0.06,
                    child: RaisedButton(
                      color: Color(0xff0E153A),
                      onPressed: () async {
                        if (bloc.formKey.currentState!.validate())
                          bloc.submitSchedule(turmaId);
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
  ManagerController _controller = ManagerController();
  DateTime date = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.bloc.listScheduleChanged(widget.horarios);
    widget.bloc.formKey = _formKey;
    super.initState();
  }

  Widget buildTopico(Horario aula, index, size) {
    return Container(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                CustomDropDown<String>(
                  title: "Dia da aula",
                  validator: (value) =>
                      value == null ? "Entre com algum dia valido" : null,
                  upDate: (value) {
                    setState(() {
                      aula.dia = value!;
                    });
                  },
                  initValue: dayBdToNormalDay(aula.dia),
                  items: [
                    'Segunda',
                    'Terca',
                    'Quarta',
                    'Quinta',
                    'Sexta',
                    'Sabado'
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.passthrough,
                        children: [
                          CustomTextField(
                            _controller,
                            label: "Inicio" + index.toString(),
                            hintText: "Inicio",
                            fillColors: Color(0xffE1E1E1),
                            hintColor: Color(0xff555555),
                            readOnly: true,
                            validator: (value) => value!.isEmpty
                                ? "Entre com "
                                    "horario"
                                : null,
                            initialValue: aula.horario != null
                                ? DateFormat("HH:MM").format(aula.horario!)
                                : null,
                            colorFont: Theme.of(context).colorScheme.primary,
                          ),
                          TextButton(
                            onPressed: () async {
                              TimeOfDay? selectedTime = await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );

                              if (selectedTime != null) {
                                _controller
                                    .controllers['Inicio${index.toString()}']!
                                    .text = selectedTime.format(context);

                                aula.horario = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    selectedTime.hour,
                                    selectedTime.minute);
                              }
                            },
                            child: Text(""),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextField(
                        _controller,
                        label: "Sala" + index.toString(),
                        upDate: (value) {
                          aula.sala = value;
                        },
                        hintText: "Sala",
                        initialValue: aula.sala,
                        fillColors: Color(0xffE1E1E1),
                        hintColor: Color(0xff555555),
                        colorFont: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                CustomDropDown<bool>(
                  title: "Tipo de aula",
                  validator: (value) =>
                      value == null ? "Entre com o tipo da aula" : null,
                  upDate: (value) {
                    setState(
                      () {
                        aula.isAssincrona = value!;
                      },
                    );
                  },
                  items: [true, false],
                  initValue: aula.isAssincrona,
                  valueSelect: (value) => value ? "Assincrona" : "Sincrona",
                ),
                SizedBox(
                  height: 10,
                ),
                aula.isAssincrona ?? false
                    ? CustomTextField(
                        _controller,
                        label: "Dias para termino" + index.toString(),
                        hintText: "Dias para termino",
                        fillColors: Color(0xffE1E1E1),
                        hintColor: Color(0xff555555),
                        textInputType: TextInputType.number,
                        suffixIcon: Tooltip(
                          message: "Quantidade de dias que o "
                              "aluno terá para avaliar a aula.",
                          child: Icon(
                            FeatherIcons.info,
                            color: Colors.black,
                          ),
                        ),
                        upDate: (value) => aula.dayToEnd = int.parse(value),
                        validator: (value) => value!.isEmpty
                            ? "Entre com "
                                "horario"
                            : null,
                        initialValue: aula.dayToEnd != null
                            ? aula.dayToEnd.toString()
                            : null,
                        colorFont: Theme.of(context).colorScheme.primary,
                      )
                    : Container()
              ],
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
                  onPressed: () {
                    widget.bloc.removeSchedule(index);
                  },
                  color: Colors.white,
                  icon: Icon(
                    FontAwesomeIcons.solidTrashAlt,
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

  Widget button() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff3D5AF1),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: TextButton(
        onPressed: () {
          widget.bloc.addSchedule();
          setState(() {});
        },
        style: TextButton.styleFrom(primary: Colors.transparent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              FeatherIcons.plus,
              color: Colors.white,
              size: 25,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: size.height * 0.6,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 0,
                minHeight: 0,
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.5,
              ),
              child: StreamBuilder<List<Horario>>(
                  stream: widget.bloc.listSchedule,
                  builder: (context, snapshot) {
                    List<Horario> listClass = <Horario>[];
                    if (snapshot.hasData && snapshot.data != null) {
                      listClass = snapshot.data!;
                    }
                    return Form(
                      key: _formKey,
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        separatorBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(right: 20, left: 10),
                            child: Divider(
                              color: Color(0xff808080),
                              height: 25,
                            ),
                          );
                        },
                        itemCount: listClass.length,
                        itemBuilder: (context, index) {
                          return buildTopico(listClass[index], index, size);
                        },
                      ),
                    );
                  }),
            ),
            button()
          ],
        ),
      ),
    );
  }
}

String? dayBdToNormalDay(day) {
  switch (day) {
    case "SEG":
      return "Segunda";
    case "TER":
      return "Terca";
    case "QUA":
      return "Quarta";
    case "QUI":
      return "Quinta";
    case "SEX":
      return "Sexta";
    case "SAB":
      return "Sabado";
  }
  return null;
}
