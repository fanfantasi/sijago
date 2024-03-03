import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/promo/promo_model.dart';
import 'package:jagomart/views/items/detail.dart';
import 'package:jagomart/views/widget/image.dart';

class AllPromoWidget extends StatelessWidget {
  final List<PromoViewModel> vp;
  AllPromoWidget({Key key, @required this.vp}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      primary: false,
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
      children: List.generate(vp?.length ?? 0, (i) {
        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ]),
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
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
                      margin: EdgeInsets.only(right: 10.0, top: 5.0),
                      child: Text(
                        '${vp[i].item}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.lato(
                            color: Colors.black87, fontSize: 14.0),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AutoSizeText(
                          'Rp. ${formatter.format(vp[i].pricedisc)}',
                          maxFontSize: 12,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                        AutoSizeText(
                          'Rp. ${formatter.format(vp[i].price)}',
                          maxFontSize: 12,
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2,
                              decorationColor: Colors.black38,
                              decorationStyle: TextDecorationStyle.double),
                        ),
                      ],
                    ),
                    // Container(
                    //     height: 15.0,
                    //     margin: EdgeInsets.only(right: 10.0, top: 5.0),
                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: <Widget>[
                    //         RatingBar.builder(
                    //           initialRating: vp[i].rating[0].rating == null
                    //               ? 0.0
                    //               : vp[i].rating[0].rating,
                    //           minRating: 1,
                    //           direction: Axis.horizontal,
                    //           allowHalfRating: true,
                    //           itemCount: 5,
                    //           itemPadding:
                    //               EdgeInsets.symmetric(horizontal: 2.0),
                    //           itemSize: 14.0,
                    //           itemBuilder: (context, _) => Icon(
                    //             Themify.star,
                    //             color: Colors.green,
                    //           ),
                    //           onRatingUpdate: (rating) {
                    //             print(rating);
                    //           },
                    //         ),
                    //         Text(
                    //           "${vp[i].rating[0].sumrating} Review",
                    //           style: TextStyle(
                    //               color: Colors.deepOrange, fontSize: 10.0),
                    //         )
                    //       ],
                    //     )),
                    Container(
                        height: 18.0,
                        margin: EdgeInsets.only(
                            right: 10.0, top: 5.0, bottom: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              '${vp[i].sould}',
                              style: TextStyle(
                                  color: Colors.green, fontSize: 10.0),
                            ),
                            AutoSizeText(" Terjual ",
                                style: GoogleFonts.lato(
                                    color: Colors.green,
                                    fontStyle: FontStyle.italic))
                          ],
                        )),
                    Divider(),
                    AutoSizeText(
                      vp[i].operasional,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.lato(
                          color: Formatter.warnaoperasional(
                              vp[i].operasionalstatus),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )));
      }),
      staggeredTiles: List.generate(vp.length, (i) {
        return StaggeredTile.fit(2);
      }),
    );
  }
}
