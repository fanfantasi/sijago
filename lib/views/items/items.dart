import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/items/items_model.dart';
import 'package:jagomart/views/items/detail.dart';
import 'package:jagomart/views/widget/image.dart';
import 'package:themify_flutter/themify_flutter.dart';

class ItemsPage extends StatelessWidget {
  final List<ItemsViewModel> vi;
  final bool isLoading;
  final ScrollController scrollViewController;
  ItemsPage(
      {Key key,
      @required this.vi,
      @required this.isLoading,
      @required this.scrollViewController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      primary: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        top: 5.0,
      ),
      itemCount: vi.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == vi.length) {
          if (isLoading) {
            return Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }

        if (index == vi.length) {
          return InkWell(
            onTap: () {
              scrollViewController.animateTo((0.0 * index),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut);
            },
            child: Container(
              padding: const EdgeInsets.only(top: 10.0),
              width: double.infinity,
              height: 100,
              child: Column(
                children: [
                  Icon(
                    Themify.angle_double_up,
                    color: Colors.grey,
                    size: 24,
                  ),
                  AutoSizeText('Batas Akhir Produk Si Jago',
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.acme(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 1.0,
                            color: Colors.black54,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          );
        }

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
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
          child: InkWell(
            onTap: () {
              push(
                  context,
                  DetailPage(
                    vi: vi[index],
                    index: index,
                  ));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: <Widget>[
                  ItemImage(images: vi[index].images),
                  //Disc
                  (vi[index].disc == null)
                      ? Container()
                      : Positioned(
                          left: 0,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${vi[index].disc} %",
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
                  //New Product
                  (vi[index].statusitem < 1)
                      ? Positioned(
                          right: 0,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Baru',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            width: 50.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: jagoRed,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12))),
                          ),
                        )
                      : Container(),
                  (vi[index].stock == 2)
                      ? Positioned(
                          bottom: 60.0,
                          right: -60.0,
                          child: Transform.rotate(
                            angle: 45.0 * pi / 180.0,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5.0),
                              height: 30,
                              width: MediaQuery.of(context).size.width / 2,
                              color: jagoRed.withOpacity(0.8),
                              child: Transform.rotate(
                                  angle: -30.0 * pi / 180.0,
                                  child: RotationTransition(
                                    turns: AlwaysStoppedAnimation(30 / 360),
                                    child: AutoSizeText(
                                      "${vi[index].group}",
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
                      : (vi[index].stock == 3)
                          ? Positioned(
                              bottom: 60.0,
                              right: -60.0,
                              child: Transform.rotate(
                                angle: 45.0 * pi / 180.0,
                                child: Container(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  height: 30,
                                  width: MediaQuery.of(context).size.width / 2,
                                  color: jagoGreen.withOpacity(0.8),
                                  child: Transform.rotate(
                                      angle: -30.0 * pi / 180.0,
                                      child: RotationTransition(
                                        turns: AlwaysStoppedAnimation(30 / 360),
                                        child: AutoSizeText(
                                          "${vi[index].group}",
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
                          : Positioned(
                              bottom: 0,
                              right: 0.0,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${vi[index].group}",
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
                ]),
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
                    '${vi[index].kategori}',
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
                  child: AutoSizeText('${vi[index].item}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      minFontSize: 14,
                      maxFontSize: 16,
                      style: GoogleFonts.lato(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Container(
                    width: MediaQuery.of(context).size.width / 2.2,
                    height: 22.0,
                    margin: EdgeInsets.only(right: 5.0, top: 5.0),
                    child: (vi[index].disc == null)
                        ? AutoSizeText(
                            'Rp. ${formatter.format(vi[index].price)}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            maxFontSize: 14,
                            style: GoogleFonts.lato(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                            ))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 5,
                                child: AutoSizeText(
                                    'Rp. ${formatter.format(vi[index].pricedisc)}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    minFontSize: 10,
                                    maxFontSize: 14,
                                    style: GoogleFonts.lato(
                                      fontSize: 13,
                                      color: Colors.pink,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 5.5,
                                child: AutoSizeText(
                                    'Rp. ${formatter.format(vi[index].price)}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    minFontSize: 10,
                                    maxFontSize: 14,
                                    style: GoogleFonts.lato(
                                        fontSize: 13,
                                        color: Colors.black38,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 2,
                                        decorationColor: Colors.black38,
                                        decorationStyle:
                                            TextDecorationStyle.double)),
                              ),
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
                        vi[index].mitra,
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
                              (vi[index].rating[0].rating == null)
                                  ? '0.0'
                                  : '${vi[index].rating[0].rating.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Colors.deepOrange, fontSize: 12.0),
                            ),
                          ],
                        ),
                        Text(
                          "${vi[index].rating[0].sumrating} Review",
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
                      vi[index].operasional,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.lato(
                          color: Formatter.warnaoperasional(
                              vi[index].operasionalstatus),
                          fontWeight: FontWeight.bold),
                    ),
                    AutoSizeText(
                      '${vi[index].distance} KM',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.lato(
                          color: Formatter.warnaoperasional(
                              vi[index].operasionalstatus),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      staggeredTileBuilder: (int index) => (index == vi.length)
          ? new StaggeredTile.fit(4)
          : new StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
