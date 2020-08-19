import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Data extends StatelessWidget {
  final ValueChanged<Widget> onPush;

  Data({this.onPush});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}
