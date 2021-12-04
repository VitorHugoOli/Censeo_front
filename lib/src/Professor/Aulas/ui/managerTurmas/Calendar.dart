import 'package:censeo/resources/professorIcons.dart';
import 'package:censeo/src/Professor/Aulas/bloc/professor.dart';
import 'package:censeo/src/Professor/Aulas/models/Aula.dart';
import 'package:censeo/src/Professor/Aulas/models/Turma.dart';
import 'package:censeo/src/Professor/Aulas/ui/managerClass/ManagerClass.dart';
import 'package:censeo/src/Professor/Aulas/ui/managerTurmas/CreateClassDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  final Map<DateTime, Aula> aulas;
  final Turma turma;
  final Bloc bloc;

  Calendar(
      {Key? key, required this.aulas, required this.bloc, required this.turma})
      : super(key: key);

  @override
  _CalendarState createState() => new _CalendarState();
}

class _CalendarState extends State<Calendar> {
  static DateTime today = DateTime.now();
  DateTime _currentDate = DateTime.now();
  DateTime _targetDateTime = DateTime.now();
  String dropdownValue = "Jan";

  late CalendarCarousel _calendarCarousel;

  static const List<String> monthList = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez'
  ];

  @override
  void initState() {
    var month = DateFormat.MMMM('pt-BR').format(today);
    dropdownValue = month.substring(0, 1).toUpperCase() + month.substring(1, 3);

    super.initState();
  }

  calendarChange(DateTime date) {
    this.setState(() {
      var month = DateFormat.MMMM('pt-BR').format(date);
      dropdownValue =
          month.substring(0, 1).toUpperCase() + month.substring(1, 3);
      _targetDateTime = date;
      // _currentDate = date;
    });
  }

  dialogCreateClass(DateTime date) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          title: CreateClassDialog.title(size, context),
          content: CreateClassDialog(date, widget.bloc),
          actions: CreateClassDialog.actions(
              context, size, date, widget.bloc, widget.turma.id!),
        );
      },
    );
  }

  dayPressed(date, _) {
    //Todo:bloquear dias já passados
    _currentDate = date;
    if (DateTime.now().difference(date).inDays > 0) return;
    if (widget.aulas.containsKey(date)) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManagerClass(widget.aulas[date]!,
                widget.turma.codigo!, widget.turma.id!, widget.bloc)),
      );
    } else {
      dialogCreateClass(date);
    }
    setState(() {});
  }

  dayBuilder(Size size) {
    Widget widgetDay(
        {required Color colorRadius,
        required Color colorText,
        required DateTime day,
        BoxShape shape = BoxShape.rectangle}) {
      var decoration = BoxDecoration();
      if (shape == BoxShape.circle) {
        decoration = BoxDecoration(
          color: colorRadius,
          shape: shape,
        );
      } else {
        decoration = BoxDecoration(
          color: colorRadius,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        );
      }

      return Container(
        decoration: decoration,
        // margin: const EdgeInsets.all(1),
        width: 80,
        height: 80,
        child: Center(
          child: Text(
            '${day.day}',
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              color: colorText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return (bool isSelectable,
        int index,
        bool isSelectedDay,
        bool isToday,
        bool isPrevMonthDay,
        TextStyle textStyle,
        bool isNextMonthDay,
        bool isThisMonthDay,
        DateTime day) {
      if (widget.aulas.containsKey(day)) {
        if (day.day == 28) {
          // Logger().i(widget.aulas[day]!.toJson());
        }
        return widgetDay(
            colorRadius: color[widget.aulas[day]!.tipoAula],
            colorText: Colors.white,
            day: day,
            shape: BoxShape.circle);
      }

      if (isNextMonthDay || isPrevMonthDay) {
        return widgetDay(
            colorRadius: Colors.transparent,
            colorText: Color.fromRGBO(34, 33, 91, 0.3),
            day: day);
      } else if (isSelectedDay) {
        return widgetDay(
            colorRadius: Color(0xff28313B),
            colorText: Colors.white,
            day: day,
            shape: BoxShape.circle);
      } else if (isToday) {
        return widgetDay(
            colorRadius: Color(0xff58f7af),
            colorText: Colors.white,
            day: day,
            shape: BoxShape.circle);
      } else {
        return widgetDay(
            colorRadius: Colors.transparent,
            colorText: Color(0xff28313B),
            day: day);
      }
    };
  }

  static const Map color = {
    null: Colors.grey,
    'teorica': Colors.amber,
    'prova': Colors.blue,
    'trabalho': Colors.red,
    'excursao': Colors.green,
  };

  buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Calendário",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xff28313b),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  calendarChange(today);
                },
                child: Icon(FontAwesomeIcons.calendarDay)),
            SizedBox(width: 10),
            //Todo:Avaliar dropdowncustom
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(ProfessorIcons.dropright, color: Color(0xff28313b)),
              iconSize: 14,
              elevation: 16,
              underline: Container(),
              style: GoogleFonts.poppins(
                color: Color(0xff28313b),
                fontSize: 25,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  calendarChange(
                      DateTime(today.year, monthList.indexOf(newValue) + 1, 1));
                });
              },
              items: monthList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value + " " + _targetDateTime.year.toString()),
                );
              }).toList(),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    /// Example with custom icon
    _calendarCarousel = CalendarCarousel(
      locale: 'pt_BR',
      pageScrollPhysics: NeverScrollableScrollPhysics(),
      selectedDayButtonColor: Colors.transparent,
      selectedDayBorderColor: Colors.transparent,
      todayBorderColor: Colors.transparent,
      todayButtonColor: Colors.transparent,
      weekDayFormat: WeekdayFormat.narrow,
      weekdayTextStyle: GoogleFonts.poppins(
        color: Color(0xaa28313B),
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      firstDayOfWeek: 0,
      showHeader: false,
      height: 290,
      childAspectRatio: 1.2,
      width: size.width,
      staticSixWeekFormat: true,
      selectedDateTime: _currentDate,
      markedDateMoreShowTotal: true,
      targetDateTime: _targetDateTime,
      minSelectedDate: DateTime(today.year - 1, 12, 31),
      maxSelectedDate: DateTime(today.year, 12, 31),
      onCalendarChanged: calendarChange,
      onDayPressed: dayPressed,
      customDayBuilder: dayBuilder(size),
      markedDateCustomShapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(100.0),
        ),
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          buildHeader(),
          _calendarCarousel,
        ],
      ),
    ); //
  }
}
