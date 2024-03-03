import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/viewmodels/ads/ads_model.dart';
import 'package:jagomart/viewmodels/ads/ads_view_model.dart';
import 'package:jagomart/views/widget/adshorizontal.dart';

class AdsPage extends StatefulWidget {
  final AdsBloc adsBloc;
  final double sizeWidth;
  final double sizeHeight;
  AdsPage(
      {Key key,
      @required this.adsBloc,
      @required this.sizeWidth,
      @required this.sizeHeight})
      : super(key: key);
  @override
  _AdsPageState createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.adsBloc.adsStream,
      builder: (context, AsyncSnapshot<List<AdsViewModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
            break;
          default:
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.data.length == 0) {
              return Container();
            }

            return Stack(
              children: [
                Container(
                    height: widget.sizeHeight,
                    width: widget.sizeWidth,
                    child: AdsHorizontalWidget(
                      va: snapshot.data,
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
                        style:
                            GoogleFonts.lato(color: Colors.white, fontSize: 10),
                      ),
                    ))
              ],
            );
        }
      },
    );
  }
}
