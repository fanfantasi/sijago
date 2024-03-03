import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/promo/promo_model.dart';
import 'package:jagomart/views/items/detail.dart';
import 'package:jagomart/views/promo/allpromo.dart';
import 'package:jagomart/views/widget/image.dart';
import 'package:themify_flutter/themify_flutter.dart';

class PromoWidget extends StatelessWidget {
  final List<PromoViewModel> vp;
  PromoWidget({Key key, @required this.vp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 0.0),
        height: 290.0,
        child: ListView.builder(
          primary: false,
          itemCount: vp.length + 1,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            if (i == vp.length) {
              return Container(
                  margin: EdgeInsets.only(right: 5, top: 5, bottom: 5),
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[100]),
                  child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (_, __, ___) => AllPromoPage(),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFFFF6969),
                            child:
                                Icon(Icons.chevron_right, color: Colors.white),
                          ),
                          AutoSizeText('Semuanya',
                              style: GoogleFonts.expletusSans(
                                fontSize: 18,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 1.0,
                                    color: Color(0xFFFF6969),
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                              ))
                        ],
                      )));
            }

            return Container(
              width: MediaQuery.of(context).size.width / 2.2,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white10,
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ]),
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
              child: InkWell(
                onTap: () {
                  push(
                      context,
                      DetailPage(
                        vi: vp[i],
                        index: i,
                      ));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        ItemImage(images: vp[i].images),
                        Positioned(
                          left: 0,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${vp[i].disc} %",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            width: 50.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: jagoRed,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8))),
                          ),
                        ),
                        (vp[i].stock == 2)
                            ? Positioned(
                                bottom: 60.0,
                                right: -60.0,
                                child: Transform.rotate(
                                  angle: 45.0 * pi / 180.0,
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    height: 30,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    color: jagoRed.withOpacity(0.8),
                                    child: Transform.rotate(
                                        angle: -30.0 * pi / 180.0,
                                        child: RotationTransition(
                                          turns:
                                              AlwaysStoppedAnimation(30 / 360),
                                          child: AutoSizeText(
                                            "${vp[i].group}",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                  ),
                                ),
                              )
                            : (vp[i].stock == 3)
                                ? Positioned(
                                    bottom: 60.0,
                                    right: -60.0,
                                    child: Transform.rotate(
                                      angle: 45.0 * pi / 180.0,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        height: 30,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        color: jagoGreen.withOpacity(0.8),
                                        child: Transform.rotate(
                                            angle: -30.0 * pi / 180.0,
                                            child: RotationTransition(
                                              turns: AlwaysStoppedAnimation(
                                                  30 / 360),
                                              child: AutoSizeText(
                                                "${vp[i].group}",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.lato(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                      ),
                                    ),
                                  )
                                : Positioned(
                                    bottom: 0,
                                    right: 0.0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "${vp[i].group}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 1.0,
                                                  color: Colors.black,
                                                  offset: Offset(1.0, 1.0),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(.35),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8))),
                                    ),
                                  ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 5.0, top: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        '${vp[i].kategori}',
                        style: TextStyle(
                          color: jagoRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      margin: EdgeInsets.only(right: 5.0, top: 5.0),
                      child: AutoSizeText('${vp[i].item}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          minFontSize: 14,
                          maxFontSize: 16,
                          style: GoogleFonts.lato(fontSize: 14)),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 2.2,
                        height: 22.0,
                        margin: EdgeInsets.only(right: 5.0, top: 5.0),
                        child: (vp[i].disc == null)
                            ? AutoSizeText(
                                'Rp. ${formatter.format(vp[i].price)}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                maxFontSize: 16,
                                style: GoogleFonts.lato(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                ))
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                      'Rp. ${formatter.format(vp[i].pricedisc)}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      maxFontSize: 16,
                                      style: GoogleFonts.lato(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  AutoSizeText(
                                      'Rp. ${formatter.format(vp[i].price)}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      maxFontSize: 16,
                                      style: GoogleFonts.lato(
                                          color: Colors.black38,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationThickness: 2,
                                          decorationColor: Colors.black38,
                                          decorationStyle:
                                              TextDecorationStyle.double)),
                                ],
                              )),
                    Row(
                      children: [
                        Icon(
                          Themify.location_pin,
                          color: Colors.green.withOpacity(0.7),
                          size: 14,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.7,
                          child: AutoSizeText(
                            vp[i].mitra,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                                color: Colors.green.withOpacity(0.7),
                                fontSize: 14.0),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 2.2,
                        height: 15.0,
                        margin: EdgeInsets.only(right: 10.0, top: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star_outline,
                                  size: 16,
                                  color: jagoGreen,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  (vp[i].rating[0].rating == null)
                                      ? '0.0'
                                      : '${vp[i].rating[0].rating.toStringAsFixed(2)}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.deepOrange, fontSize: 14.0),
                                ),
                              ],
                            ),
                            Text(
                              "${vp[i].rating[0].sumrating} Review",
                              style: TextStyle(
                                  color: Colors.deepOrange, fontSize: 10.0),
                            )
                          ],
                        )),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          vp[i].operasional,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.lato(
                              color: Formatter.warnaoperasional(
                                  vp[i].operasionalstatus),
                              fontWeight: FontWeight.bold),
                        ),
                        AutoSizeText(
                          '${vp[i].distance} KM',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.lato(
                              color: Formatter.warnaoperasional(
                                  vp[i].operasionalstatus),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
