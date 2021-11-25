import 'package:censeo/resources/Transformer.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/Professor/Aulas/ui/managerClass/FinishingClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CardClass extends StatelessWidget {
  final Aula aula;

  const CardClass({Key? key, required this.aula}) : super(key: key);

  Widget buildTop(context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aula.tema != null && aula.tema!.isNotEmpty
                      ? aula.tema!
                      : "Adicione um tema",
                  style: GoogleFonts.poppins(
                    color: aula.tema != null && aula.tema!.isNotEmpty
                        ? Color(0xff000000)
                        : Color(0x99000000),
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.49,
                  ),
                ),
                Text(
                  aula.descricao != null && aula.descricao!.isNotEmpty
                      ? aula.descricao!
                      : "Sem descrição",
                  style: GoogleFonts.poppins(
                    color: aula.descricao != null && aula.descricao!.isNotEmpty
                        ? Color(0xff000000)
                        : Color(0x99000000),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.49,
                  ),
                )
              ],
            ),
            IconButton(
              icon: Icon(
                FeatherIcons.edit2,
                color: Colors.black,
              ),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ManagerClass(
                //         aula,
                //         aula.turma!.codigo!,
                //         aula.turma!.id!,
                //         classBloc.bloc),
                //   ),
                // ).then((value) {
                //   setState(() {});
                // });
              },
            ),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  FeatherIcons.calendar,
                  size: 28,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 13,
                ),
                Text(
                  DateFormat("dd/MM/yyyy").format(aula.horario!),
                  style: GoogleFonts.poppins(
                    color: Color(0xff000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.36,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 30,
            ),
            Row(
              children: [
                Icon(
                  FeatherIcons.clock,
                  size: 28,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 13,
                ),
                Text(
                  DateFormat("kk:mm").format(aula.horario!),
                  style: GoogleFonts.poppins(
                    color: Color(0xff000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.36,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static List fields = [
    {
      'label': "Sala",
      'icon': Icon(
        FeatherIcons.home,
        size: 29,
        color: Colors.black,
      ),
    },
    {
      'label': "Link",
      'icon': Icon(
        FeatherIcons.link,
        size: 29,
        color: Colors.black,
      ),
    },
    {
      'label': "assincrona",
      'icon': Icon(
        FeatherIcons.cloud,
        size: 28,
        color: Colors.black,
      ),
    },
    {
      'label': "Tipo",
      'icon': Icon(
        FeatherIcons.airplay,
        size: 28,
        color: Colors.black,
      ),
    },
    {
      'label': "Extra",
      'icon': Icon(
        FeatherIcons.plus,
        size: 28,
        color: Colors.black,
      ),
    },
  ];

  chooseField(label) {
    switch (label) {
      case 'Sala':
        return aula.sala ?? "";
      case 'Link':
        return aula.linkDocumento ?? "";
      case 'assincrona':
        return (aula.isAssincrona ?? false ? "Assincrona" : "Sincrona");
      case 'Tipo':
        return aula.tipoAula ?? "";
      case 'Extra':
        return aula.extra![aula.tipoAula] ?? "";
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list =
        fields.where((e) => chooseField(e['label']) != "").map((e) {
      String field = chooseField(e['label']);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          e['icon'],
          SizedBox(
            width: 13,
          ),
          Text(
            capitalize(field),
            style: GoogleFonts.poppins(
              color: Color(0xff000000),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.36,
            ),
          )
        ],
      );
    }).toList();

    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          buildTop(context),
          SizedBox(height: 20),
          Wrap(
            runSpacing: 15,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: list,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
