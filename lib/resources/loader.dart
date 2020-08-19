import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  final Widget child;
  final bool loader;

  Loader({@required this.child, @required this.loader});

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        child,
        !loader
            ? Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(color: Colors.black38),
                child: Center(
//                  child: Lottie.asset('assets/loader_2.json',width: 80)
                    child: Lottie.asset('assets/loader.json', width: 150)),
              )
            : Container(),
      ],
    );
  }
}
