import 'package:censeo/resources/CustomTextField.dart';
import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
        extra: widget._aula.extra[getExtra[widget._aula.tipoAula]] ?? "");
  }

  static const getExtra = {
    'prova': 'quant_questao',
    'trabalho': 'quant_membros_grupo',
    'excursao': 'nome_local',
    'teorica': '',
  };

  static InputDecoration decoration(hint, icon, error) => InputDecoration(
        fillColor: Color(0x77ffffff),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: Color(0x88ffffff),
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.525,
        ),
        prefixIcon: Container(
            margin: EdgeInsets.only(left: 20, right: 30), child: icon),
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
      );

  Widget buildNameTitle(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
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
            height: size.height * 0.08,
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
            height: size.height * 0.08,
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
            height: size.height * 0.08,
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
              height: size.height * 0.08,
              child: snapshotType.hasData &&
                      type.toLowerCase() != "teorica" &&
                      typeField.containsKey(type)
                  ? StreamBuilder<String>(
                      stream: _classBloc.getExtra,
                      builder: (context, snapshot) {
                        return TextFormField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              String newString = 'Ȟ' +
                                  value; //Caracter adicionado para saber que o campo extra sofreu modificações
                              _classBloc.extraChanged(newString);
                            } else {
                              _classBloc.extraChanged(value);
                            }
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
                          decoration: decoration(typeField[type]['hint'],
                              typeField[type]['icon'], temaError),
                        );
                      })
                  : Container(),
            ),
          );
        });
  }

  Widget buildFieldType(size) {
    return StreamBuilder<String>(
        stream: _classBloc.getType,
        builder: (context, snapshot) {
          print(">>>>>>>>>> ${snapshot.data}");
          return Container(
            width: size.width * 0.9,
            height: size.height * 0.09,
            child: DropdownButtonFormField(
              value:
                  ((snapshot.data?.isEmpty ?? false) || snapshot.data == 'null')
                      ? null
                      : snapshot.data,
              dropdownColor: Colors.white38,
              onChanged: _classBloc.typeChanged,
              icon: Icon(
                FontAwesome.chevron_down,
                color: Colors.white,
                size: 25,
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildNameTitle(size),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                height: size.height * 0.5,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildFieldTema(size),
                      buildFieldDescription(size),
                      buildFieldLink(size),
                      buildFieldType(size),
                      buildFieldExtra(size),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              buildButtonsEdit(size)
            ],
          ),
        ),
      ),
    );
  }
}
