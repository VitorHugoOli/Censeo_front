import 'dart:convert';

import 'package:censeo/resources/CustomTextField.dart';
import 'package:censeo/resources/ScrollColumnExpandable.dart';
import 'package:censeo/resources/loader.dart';
import 'package:censeo/src/Aluno/Avaliar/bloc/aluno.dart';
import 'package:censeo/src/Login/bloc/bloc.dart';
import 'package:censeo/src/Login/ui/password.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDataPageEdit extends StatefulWidget {
  final User user;
  final BlocAluno bloc;


  PersonalDataPageEdit(this.user, this.bloc);

  @override
  _PersonalDataPageEditState createState() => _PersonalDataPageEditState();
}

class _PersonalDataPageEditState extends State<PersonalDataPageEdit> {
  ManagerController _controller = ManagerController();
  BlocLogin _blocLogin;
  final _formKey = GlobalKey<FormState>();
  bool isLoad = false;

  @override
  void initState() {
    _blocLogin = BlocLogin(widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user.toJson());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x4A3D5AF1),
        elevation: 0,
        centerTitle: true,
        title: Text('Dados Pessoais',
            style: GoogleFonts.poppins(
              color: Color(0xffffffff),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.77,
            )),
      ),
      backgroundColor: Color(0xff0E153A),
      body: Builder(
        builder: (context) => Loader(
          loader: !isLoad,
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.vertical,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x4A3D5AF1), Color(0x003D5AF1)],
                        tileMode: TileMode.clamp,
                        stops: [0, 1]),
                  ),
                  padding: EdgeInsets.only(left: 40, right: 40, bottom: 180),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextField(
                        _controller,
                        label: "Nome",
                        initialValue: widget.user.nome,
                        hasWidgetLabel: true,
                        upDate: (value) => widget.user.nome = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Entre com um nome";
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        _controller,
                        label: "Username(Opcional)",
                        initialValue: widget.user.username,
                        hasWidgetLabel: true,
                        upDate: (value) => widget.user.username = value,
                      ),
                      CustomTextField(
                        _controller,
                        label: "Email",
                        hasWidgetLabel: true,
                        initialValue: widget.user.email,
                        upDate: (value) => widget.user.email = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Entre com um email";
                          }
                          return null;
                        },
                      ),
                      Center(
                        child: Container(
                          width: 180,
                          child: FlatButton(
                            height: 50,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(6.0),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  isLoad = true;
                                });
                                dynamic response = await _blocLogin
                                    .submitPersonalData(widget.user);
                                setState(() {
                                  isLoad = false;
                                });
                                if (response == true) {
                                  var prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('user', jsonEncode(widget.user.toJson()));
                                  Navigator.pop(context);
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text(response['error']),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                }
                              }
                            },
                            color: Colors.white,
                            child: Text(
                              "Atualizar",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff3D5AF1),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
