import 'package:flutter/material.dart';


pushReplacement(BuildContext context, Widget destination) {
  Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => destination));
}

push(BuildContext context, Widget destination) {
  Navigator.of(context)
      .push(new MaterialPageRoute(builder: (context) => destination));
}

pushTransparant(BuildContext context, Widget destination) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false, 
      pageBuilder: (_, __, ___) => destination),
  );
}

pushAndRemoveUntil(BuildContext context, Widget destination, bool predict) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
      (Route<dynamic> route) => predict);
}

pushAnimation(BuildContext context, Widget destination){
  Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (context, animation, anotherAnimation) {
      return destination;
    },
    transitionDuration: Duration(milliseconds: 500),
    transitionsBuilder:
        (context, animation, anotherAnimation, child) {
      animation = CurvedAnimation(
          curve: Curves.fastLinearToSlowEaseIn, parent: animation);
      return Align(
        child: SizeTransition(
          sizeFactor: animation,
          child: child,
          axisAlignment: 0.0,
        ),
      );
    }));
}
