import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  final Widget child;
  final bool loader;
  final bool preChild;

  Loader({@required this.child, @required this.loader,this.preChild=true});

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        (!loader || preChild) ? child: Container(),
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
