import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/ads/ads_model.dart';
import 'package:jagomart/viewmodels/ads/ads_view_model.dart';
import 'package:jagomart/viewmodels/mitra/mitra_model.dart';
import 'package:jagomart/views/mitra/allmitra.dart';
import 'package:jagomart/views/mitra/detailmitra.dart';
import 'package:jagomart/views/widget/adshorizontal.dart';
import 'package:transparent_image/transparent_image.dart';

class MitraWidget extends StatelessWidget {
  final List<MitraViewModel> vm;
  final AdsBloc adsBloc;
  MitraWidget({@required this.vm, @required this.adsBloc});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final banner = size.width / 4;
    return StreamBuilder(
      stream: adsBloc.adsVerticalStream,
      builder: (context, AsyncSnapshot<List<AdsViewModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _mitra(size);
            break;
          default:
            if (snapshot.hasError) {
              return _mitra(size);
            }

            if (snapshot.data.length == 0) {
              return _mitra(size);
            }

            return _adsmitra(size, banner, snapshot.data);
        }
      },
    );
  }

  Widget _adsmitra(Size size, banner, List<AdsViewModel> snapshot) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
                height: 180,
                width: banner,
                child: AdsHorizontalWidget(
                  va: snapshot,
                )),
            Positioned(
                top: 5.0,
                left: 5.0,
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.7),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Text(
                    'Ads',
                    style: GoogleFonts.lato(color: Colors.white, fontSize: 10),
                  ),
                ))
          ],
        ),
        Expanded(
            child: Container(
          height: 180.0,
          width: size.width - 20,
          child: ListView.builder(
            itemCount: vm.length,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, i) {
              if (i == (vm.length - 1)) {
                return Container(
                    margin: EdgeInsets.only(
                      right: 5,
                    ),
                    width: size.width / 3,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[100]),
                    child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (_, __, ___) => AllMitraPage(),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color(0xFFFF6969),
                              child: Icon(Icons.chevron_right,
                                  color: Colors.white),
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
              } else {
                return Stack(children: [
                  Container(
                      width: size.width - (banner + 20),
                      height: 180.0,
                      margin: EdgeInsets.only(right: 5),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: vm[i].image,
                        fit: BoxFit.fill,
                      )),
                  Positioned(
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Container(
                          width: size.width / 1.8,
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                    text: "${vm[i].title}\n",
                                    style: GoogleFonts.righteous(
                                      fontSize: 16,
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
                                    text: "${vm[i].jam}\n",
                                    style: GoogleFonts.expletusSans(
                                      fontSize: 14,
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
                                    text: "${vm[i].operasional}\n",
                                    style: GoogleFonts.expletusSans(
                                      fontSize: 16,
                                      color: (vm[i].status)
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
                                    text: "Jarak ${vm[i].distance} KM",
                                    style: GoogleFonts.expletusSans(
                                      fontSize: 16,
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
                    bottom: 20,
                    right: 20,
                    child: Container(
                      width: 120,
                      height: 35,
                      child: FlatButton(
                        onPressed: () {
                          push(
                              context,
                              DetailMitraPage(
                                  location: vm[i].id,
                                  title: vm[i].title,
                                  image: vm[i].image,
                                  jam: vm[i].jam,
                                  jarak: vm[i].distance,
                                  operasional: vm[i].operasional));
                        },
                        padding: EdgeInsets.all(0),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: Container(
                          padding: EdgeInsets.only(left: 7, top: 5, bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text("LIHAT",
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.lato(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold))),
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
              }
            },
          ),
        ))
      ],
    );
  }

  Widget _mitra(Size size) {
    return Container(
      height: 180.0,
      width: size.width - 20,
      child: ListView.builder(
        itemCount: vm.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          if (i == (vm.length - 1)) {
            return Container(
                margin: EdgeInsets.only(
                  right: 5,
                ),
                width: size.width / 3,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[100]),
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (_, __, ___) => AllMitraPage(),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xFFFF6969),
                          child: Icon(Icons.chevron_right, color: Colors.white),
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
          } else {
            return Stack(children: [
              Container(
                  width: size.width - 20,
                  margin: EdgeInsets.only(right: 5),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: vm[i].image,
                    fit: BoxFit.fill,
                  )),
              Positioned(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Container(
                      width: size.width / 1.8,
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                                text: "${vm[i].title}\n",
                                style: GoogleFonts.righteous(
                                  fontSize: 22,
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
                                text: "${vm[i].jam}\n",
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
                                text: "${vm[i].operasional}\n",
                                style: GoogleFonts.expletusSans(
                                  fontSize: 22,
                                  color:
                                      (vm[i].status) ? Colors.green : jagoRed,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 3.0,
                                      color: Colors.black54,
                                      offset: Offset(1.0, 1.0),
                                    ),
                                  ],
                                )),
                            TextSpan(
                                text: "Jarak ${vm[i].distance} KM",
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
                bottom: 20,
                left: 20,
                child: Container(
                  width: 120,
                  height: 35,
                  child: FlatButton(
                    onPressed: () {
                      push(
                          context,
                          DetailMitraPage(
                              location: vm[i].id,
                              title: vm[i].title,
                              image: vm[i].image,
                              jam: vm[i].jam,
                              jarak: vm[i].distance,
                              operasional: vm[i].operasional));
                    },
                    padding: EdgeInsets.all(0),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Container(
                      padding: EdgeInsets.only(left: 7, top: 5, bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text("LIHAT",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold))),
                          CircleAvatar(
                            backgroundColor: Color(0xFFFF6969),
                            child:
                                Icon(Icons.chevron_right, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]);
          }
        },
      ),
    );
  }
}
