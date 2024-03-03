import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/helpers/shimmer.dart';
import 'package:jagomart/viewmodels/related/related_model.dart';
import 'package:jagomart/viewmodels/related/related_view_model.dart';
import 'package:jagomart/views/items/detail.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class RelatedNewsPage extends StatefulWidget {
  final String tags;
  RelatedNewsPage({Key key, @required this.tags}) : super(key: key);
  @override
  _RelatedNewsPageState createState() => _RelatedNewsPageState();
}

class _RelatedNewsPageState extends State<RelatedNewsPage> {
  final relatedBloc = RelatedBloc();

  @override
  void initState() {
    super.initState();
    () async {
      checklocation().then((value) {
        relatedBloc.getRelatedTop(1, Config.nearby, widget.tags);
      });
    }();
  }

  Future<String> checklocation() async {
    return Config.nearby;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: relatedBloc.relatedStream,
        builder: (context, AsyncSnapshot<List<RelatedViewModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                height: 105,
                child: ShimmerItemHorizontalList(
                  count: 1,
                ),
              );
              break;
            default:
              if (snapshot.hasError) {
                return Container();
              }

              if (snapshot.data.length == 0) {
                return Container();
              }

              return Container(
                height: 105,
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                          color: Colors.white,
                          child: InkWell(
                              onTap: () {
                                push(
                                    context,
                                    DetailPage(
                                      vi: snapshot.data[index],
                                      index: index,
                                    ));
                              },
                              child: Stack(children: [
                                Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.white),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        height: 95.0,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 5.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image: snapshot
                                                .data[index].images[0].image,
                                            fit: BoxFit.fill,
                                          ),
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              bottom: 5.0, top: 5.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.2,
                                          child: AutoSizeText(
                                            '${snapshot.data[index].item}',
                                            maxLines: 2,
                                            minFontSize: 14,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Themify.location_pin,
                                              size: 14,
                                            ),
                                            SizedBox(width: 5.0),
                                            AutoSizeText(
                                              '${snapshot.data[index].mitra} (${snapshot.data[index].distance} KM)',
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              style: GoogleFonts.lato(
                                                  fontSize: 12.0),
                                            ),
                                          ],
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.2,
                                            height: 15.0,
                                            margin:
                                                EdgeInsets.only(right: 10.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                      (snapshot
                                                                  .data[index]
                                                                  .rating[0]
                                                                  .rating ==
                                                              null)
                                                          ? '0.0'
                                                          : '${snapshot.data[index].rating[0].rating.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.deepOrange,
                                                          fontSize: 12.0),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "${snapshot.data[index].rating[0].sumrating} Review",
                                                  style: TextStyle(
                                                      color: Colors.deepOrange,
                                                      fontSize: 10.0),
                                                )
                                              ],
                                            )),
                                        Expanded(
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.2,
                                              height: 20.0,
                                              margin:
                                                  EdgeInsets.only(right: 5.0),
                                              child: (snapshot
                                                          .data[index].disc ==
                                                      null)
                                                  ? AutoSizeText(
                                                      'Rp. ${formatter.format(snapshot.data[index].price)}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      maxFontSize: 12,
                                                      style: GoogleFonts.lato(
                                                          color: Colors.pink,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              5,
                                                          child: AutoSizeText(
                                                              'Rp. ${formatter.format(snapshot.data[index].pricedisc)}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              minFontSize: 10,
                                                              maxFontSize: 12,
                                                              style: GoogleFonts.lato(
                                                                  color: Colors
                                                                      .pink,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      12)),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              5.5,
                                                          child: AutoSizeText(
                                                              'Rp. ${formatter.format(snapshot.data[index].price)}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              minFontSize: 10,
                                                              maxFontSize: 12,
                                                              style: GoogleFonts.lato(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black38,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Colors
                                                                          .black38,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .double)),
                                                        ),
                                                      ],
                                                    )),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                (snapshot.data[index].stock == 1)
                                    ? Container()
                                    : Positioned(
                                        bottom: 60.0,
                                        right: -50.0,
                                        child: Transform.rotate(
                                          angle: 45.0 * pi / 180.0,
                                          child: Container(
                                            // padding: const EdgeInsets.only(
                                            //     top: 5.0),
                                            height: 35,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            color: jagoRed.withOpacity(0.4),
                                            child: Transform.rotate(
                                                angle: -30.0 * pi / 180.0,
                                                child: RotationTransition(
                                                  turns: AlwaysStoppedAnimation(
                                                      30 / 360),
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      "${snapshot.data[index].group}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.lato(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      )
                              ])));
                    }),
              );
          }
        });
  }
}
