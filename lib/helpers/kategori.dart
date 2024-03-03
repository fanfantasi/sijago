import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';

class KategoriItem extends StatelessWidget {
  const KategoriItem({Key key, this.images, this.title, this.textcolor})
      : super(key: key);
  final String images;
  final String title;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.grey[100],
            child: CircleAvatar(
              radius: 25.0,
              backgroundColor: jagoRed,
              backgroundImage: NetworkImage(images),
            ),
          ),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(color: textcolor ?? Colors.black54),
            ),
          )
        ],
      ),
    );
  }
}
