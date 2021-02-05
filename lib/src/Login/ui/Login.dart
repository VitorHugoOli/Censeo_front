import 'package:censeo/resources/loader.dart';
import 'package:censeo/src/Aluno/BottomNavigationProfessor/BottomNavigationBar.dart';
import 'package:censeo/src/Login/bloc/bloc.dart';
import 'package:censeo/src/Login/ui/personalData.dart';
import 'package:censeo/src/Professor/BottomNavigationProfessor/BottomNavigationBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginBloc = Bloc();
  bool emailError = false;
  bool passError = false;
  String messages = "";

  final _formKey = GlobalKey<FormState>();

  Widget buildTitle(Size size) {
    return Container(
      margin: EdgeInsets.only(left: 50),
      child: Text(
        "O melhor aprendizado é a critica",
        textAlign: TextAlign.left,
        style: GoogleFonts.poppins(
            fontSize: 34,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.13),
      ),
    );
  }

  static InputDecoration decoration(label, error) => InputDecoration(
        fillColor: Color(0x78FFFFFF),
        suffixIcon: error
            ? Container(
                margin: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                width: 35,
                height: 35,
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Color(0xffffffff)),
                child: Center(
                  child: Text("!",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xff3D5AF1),
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.84,
                      )),
                ),
              )
            : null,
        filled: true,
        errorStyle: TextStyle(),
        contentPadding: EdgeInsets.only(top: 0, left: 20),
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

  dynamic validatorEmail(value) {
    final reg = RegExp(r'/^[a-z0-9.]+@[a-z0-9]+\.[a-z]+\.([a-z]+)?$/i');
    if (value.isEmpty) {
      setState(() {
        emailError = true;
        messages = "Entre com um email.";
      });
      return "";
    } else if (reg.hasMatch(value)) {
      setState(() {
        emailError = true;
        messages = "Entre com um email valido.";
      });
      return "";
    }
    setState(() {
      emailError = false;
    });
    return null;
  }

  Widget buildFieldLogin(Size size) {
    return StreamBuilder<String>(
        stream: loginBloc.email,
        builder: (context, snapshot) {
          return Container(
            width: size.width * 0.75,
            height: size.height * 0.08,
            child: TextFormField(
              onChanged: loginBloc.emailChanged,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                color: Color(0xffffffff),
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.735,
              ),
              decoration: decoration("", emailError),
              validator: (value) => validatorEmail(value),
            ),
          );
        });
  }

  dynamic validatorPass(value) {
    if (value.isEmpty) {
      if (!emailError) {
        setState(() {
          passError = true;
          messages = "Entre com uma senha.";
        });
      }
      return "";
    }

    setState(() {
      passError = false;
    });
    return null;
  }

  Widget buildFieldPassword(Size size) {
    return StreamBuilder<String>(
        stream: loginBloc.password,
        builder: (context, snapshot) {
          return Container(
            width: size.width * 0.75,
            child: TextFormField(
              onChanged: loginBloc.passwordChanged,
              keyboardType: TextInputType.text,
              obscureText: true,
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                color: Color(0xffffffff),
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.735,
              ),
              validator: (value) => validatorPass(value),
              decoration: decoration("", passError),
            ),
          );
        });
  }

  void submitLogin(snapshot) async {
    setState(() {
      passError = false;
      emailError = false;
    });

    if (_formKey.currentState.validate()) {
      Map response = await loginBloc.submit(snapshot.data);

      if (response['status']) {

        if (response['user'].firstTime == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PersonalDataPage(response['user']),
            ),
          );
          return;
        }

        if (response['type'] == "Professor") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigationProfessor(),
            ),
          );
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BottomNavigationAluno()));
        }

        return;
      } else {
        setState(() {
          messages = response['message'];
          passError = (response['message'] == "Senha incorreta.");
          emailError = ((response['message'] == "" ? false : true) &&
              !(response['message'] == "Senha incorreta."));
        });
        return;
      }
    }
  }

  Widget buildLoginInButton(size) {
    return Container(
      width: size.width * 0.6,
      height: size.height * 0.08,
      child: StreamBuilder<Map>(
          stream: loginBloc.submitCheck,
          builder: (context, snapshot) {
            return RaisedButton(
              color: Colors.white,
              onPressed: () => submitLogin(snapshot),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                "Log In",
                style: GoogleFonts.poppins(
                  color: Color(0xff3D5AF1),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.875,
                ),
              ),
            );
          }),
    );
  }

  Widget buildRescue(size) {
    return RaisedButton(
      color: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.all(0),
      onPressed: () {},
      child: Text(
        "Resgatar Senha",
        textAlign: TextAlign.start,
        style: GoogleFonts.poppins(
          color: Color(0xff3390FF),
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.56,
        ),
      ),
    );
  }

  Widget buildAlertMessageMux(Size size, bool isEmail) {
    return AnimatedOpacity(
      duration: Duration(seconds: 3),
      opacity: (emailError || passError) ? 1.0 : 0.0,
      curve: Curves.easeIn,
      child: Container(
          width: size.width,
          height: size.height * 0.044,
          margin: EdgeInsets.only(bottom: 5, top: 3),
          child: (emailError && isEmail)
              ? buildAlertMessage(size)
              : (passError && !isEmail)
                  ? buildAlertMessage(size)
                  : Container()),
    );
  }

  Widget buildAlertMessage(Size size) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            right: size.width * 0.05,
            child: Container(
              height: size.height * 0.044,
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xffffffff),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    height: size.height * 0.13,
                    child: Center(
                      child: Text(
                        messages,
                        style: GoogleFonts.poppins(
                          color: Color(0xff3E3C3C),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.735,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget m_e_s(String mes) {
    return Container(
      child: Text(
        mes,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.735,
        ),
      ),
      padding: EdgeInsets.only(bottom: 3, left: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Loader(
          loader: true,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  height: size.height - MediaQuery.of(context).padding.top,
                  decoration: BoxDecoration(
                    color: Color(0xff0E153A),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x4A3D5AF1), Color(0x003D5AF1)],
                          tileMode: TileMode.clamp,
                          stops: [0, 1]),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildTitle(size),
                        buildAlertMessageMux(size, true),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  m_e_s("Matrícula"),
                                  buildFieldLogin(size),
                                ],
                              ),
                              buildAlertMessageMux(size, false),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  m_e_s("Senha"),
                                  buildFieldPassword(size),
                                  buildRescue(size),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.065,
                              ),
                              buildLoginInButton(size),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
