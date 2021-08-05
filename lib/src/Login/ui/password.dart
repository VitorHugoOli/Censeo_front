import 'package:censeo/resources/CustomTextField.dart';
import 'package:censeo/resources/ScrollColumnExpandable.dart';
import 'package:censeo/resources/loader.dart';
import 'package:censeo/src/Aluno/BottomNavigationProfessor/BottomNavigationBar.dart';
import 'package:censeo/src/Login/bloc/bloc.dart';
import 'package:censeo/src/Professor/BottomNavigationProfessor/BottomNavigationBar.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordPage extends StatefulWidget {
  final BlocLogin blocLogin;

  PasswordPage(this.blocLogin);

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  ManagerController _controller = ManagerController();
  final _formKey = GlobalKey<FormState>();
  bool isLoad = false;
  String pass;
  String passConfirm;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E153A),
      body: Builder(
        builder: (context) => Loader(
          loader: !isLoad,
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x4A3D5AF1), Color(0x003D5AF1)],
                        tileMode: TileMode.clamp,
                        stops: [0, 1]),
                  ),
                  padding: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Óla,\nSeja Bem\nVindo!",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "E por fim faça uma nova senha",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 17.90,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CustomTextField(
                        _controller,
                        label: "Nova Senha",
                        hasWidgetLabel: true,
                        upDate: (value) => pass = value,
                        pass: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Entre com uma senha";
                          }
                          return null;
                        }
                      ),
                      CustomTextField(
                        _controller,
                        label: "Confirme a senha",
                        hasWidgetLabel: true,
                        upDate: (value) => passConfirm = value,
                        pass: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Confirme a senha a cima";
                          } else if (pass != passConfirm) {
                            return "As Senhas não são compativeis";
                          }
                          return null;
                        },
                      ),
                      Center(
                        child: Container(
                          width: 200,
                          child: FlatButton(
                            height: 60,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(6.0),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  isLoad = true;
                                });
                                dynamic response = await widget.blocLogin
                                    .submitPass(passConfirm);
                                setState(() {
                                  isLoad = false;
                                });
                                if (response is User) {
                                  if (response.type == "Professor") {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BottomNavigationProfessor(),
                                      ),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BottomNavigationAluno()),
                                    );
                                  }
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
                              "Finalizar",
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
