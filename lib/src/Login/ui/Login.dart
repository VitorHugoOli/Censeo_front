import 'package:censeo/src/Login/bloc/bloc.dart';
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
      height: size.height * 0.385,
      child: Stack(
        children: <Widget>[
          SvgPicture.asset(
            'assets/ori_bubbles.svg',
            width: size.width,
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
          ),
          Center(
            heightFactor: 4,
            widthFactor: 1.2,
            child: Text(
              "O melhor aprendizado é\n a critica",
              textAlign: TextAlign.left,
              style: TextStyle(fontFamily: "Myriad Pro", fontSize: 28, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  InputDecoration decoration(label, error) => InputDecoration(
        fillColor: Color(0x78FFFFFF),
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
          color: Color(0xffffffff),
          fontSize: 21,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.735,
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
              decoration: decoration("Matrícula", emailError),
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
            height: size.height * 0.08,
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
              decoration: decoration("Senha", passError),
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
        if (response['type'] == "Professor") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationProfessor()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationProfessor()));
        }
        return;
      } else {
        setState(() {
          messages = response['message'];
          passError = (response['message'] == "Senha incorreta.");
          emailError = ((response['message'] == "" ? false : true) && !(response['message'] == "Senha incorreta."));
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
                  color: Color(0xffff3f85),
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.875,
                ),
              ),
            );
          }),
    );
  }

  Widget buildRescue(size) {
    return Container(
      width: size.width * 0.45,
      height: size.height * 0.06,
      child: RaisedButton(
        color: Colors.white,
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(76),
        ),
        child: Text(
          "Resgatar Senha",
          style: GoogleFonts.poppins(
            color: Color(0xff4b2e9d),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            letterSpacing: -0.56,
          ),
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
              : (passError && !isEmail) ? buildAlertMessage(size) : Container()),
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: size.height - MediaQuery.of(context).padding.top,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff7e00de), Color(0xffff3f85)],
                    begin: Alignment.topLeft,
                    end: Alignment(0.5, 1.1),
                    stops: [0.3572, 0.9606],
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    buildTitle(size),
                    buildAlertMessageMux(size, true),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          buildFieldLogin(size),
                          buildAlertMessageMux(size, false),
                          buildFieldPassword(size),
                          SizedBox(
                            height: size.height * 0.065,
                          ),
                          buildLoginInButton(size),
                          SizedBox(
                            height: 30,
                          ),
                          buildRescue(size),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
