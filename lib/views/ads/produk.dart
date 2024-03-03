import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/adsitems/adsitems_model.dart';
import 'package:jagomart/views/ads/detailproduk.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class ProdukAdsWidget extends StatelessWidget {
  final List<AdsItemsViewModel> vi;
  final bool isLoading;
  final distance;
  final title;
  final phone;
  final ScrollController scrollViewController;
  ProdukAdsWidget(
      {Key key,
      @required this.vi,
      @required this.distance,
      @required this.title,
      @required this.phone,
      @required this.isLoading,
      @required this.scrollViewController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      primary: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 5.0),
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

        return Card(
            color: Colors.white,
            child: InkWell(
                onTap: () {
                  push(
                      context,
                      DetailProdukAds(
                        vi: vi[index],
                        phone: phone,
                        title: title,
                        distance: distance,
                      ));
                },
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white),
                                width: MediaQuery.of(context).size.width / 2.2,
                                height: 120.0,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: vi[index].image,
                                    fit: BoxFit.fill,
                                  ),
                                )),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    width:
                                        MediaQuery.of(context).size.width / 2.2,
                                    child: AutoSizeText(
                                      '${vi[index].title}',
                                      maxLines: 3,
                                      minFontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Themify.location_pin,
                                        size: 14,
                                      ),
                                      SizedBox(width: 5.0),
                                      AutoSizeText(
                                        '$distance KM',
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: GoogleFonts.lato(fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Themify.tag,
                                        size: 14,
                                      ),
                                      SizedBox(width: 5.0),
                                      AutoSizeText(
                                        '${vi[index].jenis}',
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: GoogleFonts.lato(fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.2,
                                      height: 22.0,
                                      margin:
                                          EdgeInsets.only(right: 5.0, top: 5.0),
                                      child: AutoSizeText(
                                          'Rp. ${formatter.format(vi[index].price)}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          maxFontSize: 14,
                                          style: GoogleFonts.lato())),
                                ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  (vi[index].stock == '1')
                      ? Container()
                      : Positioned(
                          bottom: 60.0,
                          right: -50.0,
                          child: Transform.rotate(
                            angle: 45.0 * pi / 180.0,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5.0),
                              height: 35,
                              width: MediaQuery.of(context).size.width / 2,
                              color: jagoRed.withOpacity(0.4),
                              child: Transform.rotate(
                                  angle: -30.0 * pi / 180.0,
                                  child: RotationTransition(
                                    turns: AlwaysStoppedAnimation(30 / 360),
                                    child: AutoSizeText(
                                      "${vi[index].stock}",
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
                ])));
      },
      staggeredTileBuilder: (int index) => (index == vi.length)
          ? new StaggeredTile.fit(4)
          : new StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
