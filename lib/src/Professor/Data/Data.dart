import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Data extends StatelessWidget {
  final ValueChanged<Widget> onPush;

  Data({this.onPush});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E153A),
      appBar: AppBar(title: Text("Dados Professor"),),
      body: Container(
        constraints: BoxConstraints.expand(),
      ),
    );
  }
}
