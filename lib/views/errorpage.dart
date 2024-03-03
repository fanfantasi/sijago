import 'package:flutter/material.dart';
import 'package:themify_flutter/themify_flutter.dart';

class ErrorPage extends StatelessWidget {
  final double height;
  ErrorPage(this.height);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        child: Icon(
          Themify.unlink,
          color: Color(0xFFe60f4c),
          size: 75.0,
        ),
      ),
    );
  }
}
