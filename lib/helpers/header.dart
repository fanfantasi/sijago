import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HeaderItem extends StatelessWidget {
  const HeaderItem({Key key, this.images, this.title, this.textcolor, this.tag})
      : super(key: key);
  final IconData images;
  final String title;
  final String tag;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      child: Column(
        children: <Widget>[
          Hero(tag: tag, child: Icon(images, color: textcolor ?? Colors.white)),
          SizedBox(
            height: 10,
          ),
          AutoSizeText(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: textcolor ?? Colors.white),
          )
        ],
      ),
    );
  }
}
