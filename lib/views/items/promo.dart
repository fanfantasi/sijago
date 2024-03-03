import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/shimmer.dart';
import 'package:jagomart/viewmodels/ads/ads_view_model.dart';
import 'package:jagomart/viewmodels/promo/promo_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/ads/ads.dart';
import 'package:jagomart/views/widget/promo.dart';

class PromoPage extends StatefulWidget {
  final PromoBloc promoBloc;
  final AdsBloc adsBloc;
  PromoPage({Key key, @required this.promoBloc, @required this.adsBloc})
      : super(key: key);
  @override
  _PromoPageState createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.promoBloc.promoStream,
      builder: (context, AsyncSnapshot<List<PromoViewModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Column(
              children: [
                Row(
                  children: <Widget>[
                    Container(
                      width: 3,
                      height: 20,
                      color: jagoRed,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Flexible(
                      child: AutoSizeText("Promo",
                          maxLines: 1,
                          maxFontSize: 22,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                ShimmerItemHorizontal(
                  count: 6,
                )
              ],
            );
            break;
          default:
            if (snapshot.hasError) {
              return Container();
            }

            return Column(
              children: [
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 3,
                      height: 20,
                      color: jagoRed,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Flexible(
                      child: AutoSizeText("Promo",
                          maxLines: 1,
                          maxFontSize: 22,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Divider(),
                AdsPage(
                  sizeHeight: 140,
                  sizeWidth: MediaQuery.of(context).size.width,
                  adsBloc: widget.adsBloc,
                ),
                PromoWidget(
                  vp: snapshot.data,
                )
              ],
            );
        }
      },
    );
  }
}
