import 'package:censeo/resources/Avatar.dart';
import 'package:censeo/src/Aluno/Avaliar/bloc/aluno.dart';
import 'package:censeo/src/Aluno/Avaliar/models/Avatar.dart' as avatarModel;
import 'package:censeo/src/Aluno/Avaliar/ui/password.dart';
import 'package:censeo/src/Aluno/Avaliar/ui/personalData.dart';
import 'package:censeo/src/User/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  final User user;
  final BlocAluno bloc;

  const Settings({Key? key, required this.user, required this.bloc})
      : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Widget buildDS(Size size, context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    PersonalDataPageEdit(widget.user, widget.bloc),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  child: Text(
                    'Dados Pessoais',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.525,
                    ),
                  ),
                ),
                Icon(
                  FeatherIcons.chevronRight,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Color(0xffD0D0D0),
                height: 4,
              )),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PasswordPageEdit(widget.user),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  child: Text('Trocar Senha',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.525,
                      )),
                ),
                Icon(
                  FeatherIcons.chevronRight,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAvatar(Size size, context) {
    return FutureBuilder<List<avatarModel.Avatar>>(
      future: widget.bloc.fetchAvatares(),
      initialData: [],
      builder: (context, snapshot) {
        List<avatarModel.Avatar> list = snapshot.data ?? [];
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Avatares',
                style: GoogleFonts.poppins(
                  color: Color(0xff000000),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.77,
                ),
              ),
              GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: list
                    .map((e) => GestureDetector(
                          onTap: () async {
                            await widget.bloc
                                .selectAvatar(e.avatarU?.id, e.avatarU?.url);
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                // widget.bloc.staticUser.typeId ==
                                shape: BoxShape.circle,
                                color: (e.isActive ??
                                            widget.bloc.staticUser
                                                    .perfilPhoto ==
                                                null) ==
                                        true
                                    ? Color(0xff90EC6F)
                                    : Color(0xffE2F3F5)),
                            padding: EdgeInsets.all(3),
                            child: Avatar(
                              e.avatarU?.url,
                              heightPhoto: 400,
                            ),
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xff0E153A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Configurações',
            style: GoogleFonts.poppins(
              color: Color(0xffffffff),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.77,
            )),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(left: 15, right: 15, top: 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildDS(size, context),
              SizedBox(height: 13),
              Flexible(fit: FlexFit.loose, child: buildAvatar(size, context))
            ],
          ),
        ),
      ),
    );
  }
}
