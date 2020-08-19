import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Suggestions extends StatelessWidget {
  final ValueChanged<Widget> onPush;

  Suggestions({this.onPush});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
