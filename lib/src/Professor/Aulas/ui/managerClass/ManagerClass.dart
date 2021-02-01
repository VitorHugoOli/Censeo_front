import 'package:censeo/resources/CustomTextField.dart';
import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ManagerClass extends StatefulWidget {
  final Aula _aula;
  final String siglaTurma;
  final int idTurma;
  final Bloc bloc;

  ManagerClass(this._aula, this.siglaTurma, this.idTurma, this.bloc);

  @override
  _ManagerClassState createState() => _ManagerClassState();
}

class _ManagerClassState extends State<ManagerClass> {
  ClassBloc _classBloc;
  bool temaError = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _temaController = TextEditingController(text: "");
  TextEditingController _descriptionController =
      TextEditingController(text: "");
  TextEditingController _linkController = TextEditingController(text: "");
  TextEditingController _extraController = TextEditingController(text: "");
  bool isAssincrona = false;

  @override
  void initState() {
    super.initState();
    print(widget._aula.toJson());
    _temaController.text = widget._aula.tema;
    _descriptionController.text = widget._aula.descricao;
    _linkController.text = widget._aula.linkDocumento;
    _extraController.text =
        widget._aula.extra[getExtra[widget._aula.tipoAula]] ?? "";

    _classBloc = ClassBloc(widget.bloc,
        tema: widget._aula.tema,
        description: widget._aula.tema,
        link: widget._aula.linkDocumento,
        type: widget._aula.tipoAula,
        isAssincrona: widget._aula.isAssincrona,
        extra: widget._aula.extra[getExtra[widget._aula.tipoAula]] ?? "");
  }

  static const getExtra = {
    'prova': 'quant_questao',
    'trabalho': 'quant_membros_grupo',
    'excursao': 'nome_local',
    'teorica': '',
  };

  Widget buildNameTitle(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Hero(
          tag: "horario_class",
          child: Text(
            widget.siglaTurma,
            style: GoogleFonts.poppins(
              color: Color(0xffffffff),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.77,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            DateFormat.Md("pt_BR").format(widget._aula.horario),
            style: GoogleFonts.poppins(
              color: Color(0xffffffff),
              fontSize: 19,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.49,
            ),
          ),
        ),
        Text(
          widget._aula.sala.toUpperCase(),
          style: GoogleFonts.poppins(
            color: Color(0xffffffff),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            letterSpacing: -0.49,
          ),
        ),
      ],
    );
  }

  Widget buildFieldTema(size) {
    return StreamBuilder<String>(
        stream: _classBloc.getTema,
        builder: (context, snapshot) {
          return Container(
            width: size.width * 0.9,
            child: TextFormField(
              onChanged: _classBloc.temaChanged,
              controller: _temaController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                color: Color(0xffffffff),
                fontSize: 19,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.735,
              ),
              decoration: CustomTextField.formDecoration(
                "Digite o tema da aula",
                prefixIcon: Icon(
                  FontAwesome.graduation_cap,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
          );
        });
  }

  Widget buildFieldDescription(size) {
    return StreamBuilder<String>(
        stream: _classBloc.getDescription,
        builder: (context, snapshot) {
          return Container(
            width: size.width * 0.9,
            child: TextFormField(
              onChanged: _classBloc.descriptionChanged,
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                color: Color(0xffffffff),
                fontSize: 19,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.735,
              ),
              decoration: CustomTextField.formDecoration(
                "Digite a descrição",
                prefixIcon: Icon(
                  Feather.info,
                  size: 29,
                  color: Colors.white,
                ),
              ),
            ),
          );
        });
  }

  Widget buildFieldLink(size) {
    return StreamBuilder<String>(
        stream: _classBloc.getLink,
        builder: (context, snapshot) {
          return Container(
            width: size.width * 0.9,
            child: TextFormField(
              onChanged: _classBloc.linkChanged,
              controller: _linkController,
              keyboardType: TextInputType.multiline,
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                color: Color(0xffffffff),
                fontSize: 19,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.735,
              ),
              decoration: CustomTextField.formDecoration(
                "Link sobre a aula (Opcional)",
                prefixIcon: Icon(
                  Feather.link,
                  size: 29,
                  color: Colors.white,
                ),
              ),
            ),
          );
        });
  }

  Widget buildFieldExtra(size) {
    const Map typeField = {
      'prova': {
        'hint': 'Quantidade de questões da prova(Opcional)',
        'type': TextInputType.number,
        'icon': Icon(
          Feather.paperclip,
          color: Colors.white,
          size: 29,
        )
      },
      'trabalho': {
        'hint': 'Quantidade de membros por grupo(Opcional)',
        'type': TextInputType.number,
        'icon': Icon(
          FontAwesome.group,
          color: Colors.white,
          size: 29,
        )
      },
      'excursao': {
        'hint': 'Nome do local(Opcional)',
        'type': TextInputType.text,
        'icon': Icon(
          Feather.map_pin,
          color: Colors.white,
          size: 29,
        )
      },
      'teorica': {
        'hint': '',
        'type': TextInputType.text,
        'icon': Icon(Feather.github)
      }
    };

    return StreamBuilder<String>(
        stream: _classBloc.getType,
        builder: (context, snapshotType) {
          var type = removeDiacritics(snapshotType.data ?? "").toLowerCase();
          print(type);
          return AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: snapshotType.hasData && type != "Teorica" ? 1 : 0,
            child: Container(
              width: size.width * 0.9,
              child: snapshotType.hasData &&
                      type.toLowerCase() != "teorica" &&
                      typeField.containsKey(type)
                  ? StreamBuilder<String>(
                      stream: _classBloc.getExtra,
                      builder: (context, snapshot) {
                        return TextFormField(
                          onChanged: (value) {
                            _classBloc.extraChanged(value);
                          },
                          controller: _extraController,
                          keyboardType: typeField[type]['type'],
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            color: Color(0xffffffff),
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.735,
                          ),
                          decoration: CustomTextField.formDecoration(
                              typeField[type]['hint'],
                              prefixIcon: typeField[type]['icon']),
                        );
                      })
                  : Container(),
            ),
          );
        });
  }

  Widget buildFieldIsAssincrona(size) {
    return Container(
      width: size.width * 0.9,
      child: StreamBuilder<bool>(
          stream: _classBloc.getIsAssincrona,
          builder: (context, snapshot) {
            return DropdownButtonFormField(
              value: (snapshot.hasData) ? snapshot.data : true,
              dropdownColor: Colors.white38,
              onChanged: _classBloc.isAssincronaChanged,
              icon: Icon(
                FeatherIcons.chevronDown,
                color: Colors.white,
                size: 28,
              ),
              decoration: CustomTextField.formDecoration(
                "Entre com o tipo",
                prefixIcon: Icon(
                  FeatherIcons.cloud,
                  size: 26,
                  color: Colors.white,
                ),
              ),
              items:
                  <bool>[true, false].map<DropdownMenuItem<bool>>((bool value) {
                return DropdownMenuItem<bool>(
                  value: value,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      value ? "Assincrona" : "Sincrona",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.63,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }

  Widget buildFieldType(size) {
    return StreamBuilder<String>(
        stream: _classBloc.getType,
        builder: (context, snapshot) {
          return Container(
            width: size.width * 0.9,
            child: DropdownButtonFormField(
              value:
                  ((snapshot.data?.isEmpty ?? false) || snapshot.data == 'null')
                      ? null
                      : snapshot.data,
              dropdownColor: Colors.white38,
              onChanged: _classBloc.typeChanged,
              icon: Icon(
                FeatherIcons.chevronDown,
                color: Colors.white,
                size: 28,
              ),
              decoration: CustomTextField.formDecoration(
                "Entre com o tipo",
                prefixIcon: Icon(
                  FontAwesome.user_circle,
                  size: 26,
                  color: Colors.white,
                ),
              ),
              items: <String>['Teorica', 'Prova', 'Trabalho', 'Excursão']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: removeDiacritics(value).toLowerCase(),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.63,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        });
  }

  submitClassEdit() {
    if (_formKey.currentState.validate()) {
      _classBloc.submitEditClass(
          idAula: widget._aula.id, idTurma: widget.idTurma);
    }
  }

  Widget buildButtonsEdit(Size size) {
    return Container(
      width: size.width * 0.9,
      margin: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width * 0.40,
            child: RaisedButton(
              color: Colors.white,
              onPressed: () {
                _classBloc.submitDeleteClass(
                  idAula: widget._aula.id,
                  idTurma: widget.idTurma,
                );
                submitClassEdit();
                Navigator.of(context).pop();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Cancelar Aula",
                style: GoogleFonts.poppins(
                  color: Color(0xff0E153A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.63,
                ),
              ),
            ),
          ),
          Container(
            width: size.width * 0.40,
            child: RaisedButton(
              color: Color(0xff3D5AF1),
              onPressed: () {
                submitClassEdit();
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Salvar",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.63,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xff0E153A),
      body: Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 0),
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buildNameTitle(size),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildFieldTema(size),
                            buildFieldDescription(size),
                            buildFieldLink(size),
                            buildFieldIsAssincrona(size),
                            buildFieldType(size),
                            buildFieldExtra(size),
                          ],
                        ),
                      ),
                    ),
                    buildButtonsEdit(size)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
