import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/helpers/shimmer.dart';
import 'package:jagomart/viewmodels/mitra/mitra_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/mitra/detailmitra.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class AllMitraPage extends StatefulWidget {
  @override
  _AllMitraPageState createState() => _AllMitraPageState();
}

class _AllMitraPageState extends State<AllMitraPage> {
  final mitraBloc = MitraBloc();
  bool isLoading = false;
  ScrollController _scrollController;
  int pageCount = 1;

  @override
  void initState() {
    mitraBloc.getMitraTop(1, Config.nearby);
    super.initState();
    _scrollController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        isLoading = true;
      });

      if (isLoading) {
        pageCount = pageCount + 1;
        getData(pageCount);
      }
    }
  }

  void getData(pageCount) async {
    bool mitra = await mitraBloc.getMitra(pageCount, Config.nearby);
    if (!mitra) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                )
              ], color: Colors.white),
              height: 60.0,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Themify.folder,
                          color: jagoRed,
                          size: 24,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Mitra Kami',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 18.0, color: jagoRed),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: mitraBloc.mitraStream,
                builder:
                    (context, AsyncSnapshot<List<MitraViewModel>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                          child: ListView.builder(
                        itemCount: 4,
                        itemBuilder: (context, i) {
                          return ShimmerMitra();
                        },
                      ));
                      break;
                    default:
                      if (snapshot.hasError) {
                        return Container();
                      }

                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        controller: _scrollController,
                        itemCount: snapshot.data.length + 1,
                        itemBuilder: (context, i) {
                          if (i == snapshot.data.length) {
                            if (isLoading) {
                              return Container(
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          }

                          if (i == snapshot.data.length) {
                            return InkWell(
                              onTap: () {
                                _scrollController.animateTo((0.0 * i),
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
                                    AutoSizeText('Batas Akhir Mitra Si Jago',
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

                          return Stack(children: [
                            Container(
                                width: double.infinity,
                                height: 200.0,
                                margin: EdgeInsets.all(5),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: snapshot.data[i].image,
                                  fit: BoxFit.fill,
                                )),
                            Positioned(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(color: Colors.white),
                                        children: [
                                          TextSpan(
                                              text:
                                                  "${snapshot.data[i].title}\n",
                                              style: GoogleFonts.righteous(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 2.0,
                                                    color: Colors.black38,
                                                    offset: Offset(2.0, 3.0),
                                                  ),
                                                ],
                                              )),
                                          TextSpan(
                                              text: "${snapshot.data[i].jam}\n",
                                              style: GoogleFonts.expletusSans(
                                                fontSize: 18,
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 3.0,
                                                    color: Colors.black54,
                                                    offset: Offset(1.0, 1.0),
                                                  ),
                                                ],
                                              )),
                                          TextSpan(
                                              text:
                                                  "${snapshot.data[i].operasional}\n",
                                              style: GoogleFonts.expletusSans(
                                                fontSize: 22,
                                                color: (snapshot.data[i].status)
                                                    ? Colors.green
                                                    : jagoRed,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 3.0,
                                                    color: Colors.black54,
                                                    offset: Offset(1.0, 1.0),
                                                  ),
                                                ],
                                              )),
                                          TextSpan(
                                              text:
                                                  "Jarak ${snapshot.data[i].distance} KM",
                                              style: GoogleFonts.expletusSans(
                                                fontSize: 22,
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 3.0,
                                                    color: Colors.black54,
                                                    offset: Offset(1.0, 1.0),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Container(
                                width: 100,
                                height: 35,
                                child: FlatButton(
                                  onPressed: () {
                                    push(
                                        context,
                                        DetailMitraPage(
                                            location: snapshot.data[i].id,
                                            title: snapshot.data[i].title,
                                            image: snapshot.data[i].image,
                                            jam: snapshot.data[i].jam,
                                            jarak: snapshot.data[i].distance,
                                            operasional:
                                                snapshot.data[i].operasional));
                                  },
                                  padding: EdgeInsets.all(0),
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 7, top: 5, bottom: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text("LIHAT",
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.lato(
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        CircleAvatar(
                                          backgroundColor: Color(0xFFFF6969),
                                          child: Icon(Icons.chevron_right,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]);
                        },
                      );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
