import 'package:censeo/resources/CustomTextField.dart';
import 'package:censeo/resources/ScrollColumnExpandable.dart';
import 'package:censeo/resources/loader.dart';
import 'package:censeo/src/Login/bloc/bloc.dart';
import 'package:censeo/src/Login/ui/password.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalDataPage extends StatefulWidget {
  final User user;
  PersonalDataPage(this.user);

  @override
  _PersonalDataPageState createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
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
                  child: Wrap(
                    runSpacing: 10,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.start,
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
                        "Antes de comerçarmos,\nprecisamos que preencha\nalguns dados",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 17.90,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                                dynamic response =
                                    await _blocLogin.submitPersonalData(widget.user);
                                setState(() {
                                  isLoad = false;
                                });
                                if (response == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PasswordPage(_blocLogin),
                                    ),
                                  );
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
                              "Próximo",
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
