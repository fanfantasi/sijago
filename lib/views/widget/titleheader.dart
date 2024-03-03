import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final String title;

  PersistentHeader(this.title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
      child: Container(
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 3,
                height: 20,
                color: (shrinkOffset == 0.0) ? jagoRed : Colors.black87,
              ),
              SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: AutoSizeText("$title",
                    maxLines: 1,
                    maxFontSize: 22,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.lato(
                        color: (shrinkOffset == 0.0) ? Colors.black87 : jagoRed,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  @override
  double get maxExtent => 40.0;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
