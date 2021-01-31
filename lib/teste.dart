 import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E153A),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Texto(
                    "Didadica",
                  )
                ],
              ),
            ),
            Texto(
              number.toString(),
              color: Colors.white,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      number--;
                    });
                  },
                  child: Text("Decrementa"),
                ),
                FlatButton(
                  color: Colors.green,
                  onPressed: () {
                    setState(() {
                      number++;
                    });
                  },
                  child: Text("Incrementa"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Texto extends StatelessWidget {
  final String texto;
  final Color color;

  Texto(this.texto, {this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(fontSize: 20, color: color),
    );
  }
}