import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/shimmer.dart';
import 'package:jagomart/viewmodels/ads/ads_view_model.dart';
import 'package:jagomart/viewmodels/mitra/mitra_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/widget/mitra.dart';

class MitraPage extends StatefulWidget {
  final MitraBloc mitraBloc;
  final AdsBloc adsBloc;
  MitraPage({Key key, @required this.mitraBloc, @required this.adsBloc})
      : super(key: key);
  @override
  _MitraPageState createState() => _MitraPageState();
}

class _MitraPageState extends State<MitraPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.mitraBloc.mitraStream,
      builder: (context, AsyncSnapshot<List<MitraViewModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5.0),
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey[300]),
                  child: Column(
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
                            child: AutoSizeText("Mitra Si JagoMart",
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
                      ShimmerMitra()
                    ],
                  ),
                ),
              ],
            );
            break;
          default:
            if (snapshot.hasError) {
              return Container();
            }

            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                        child: AutoSizeText("Mitra UMKM",
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 0),
                    child: Text(
                      'Sponsored',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Divider(),
                  MitraWidget(
                    vm: snapshot.data,
                    adsBloc: widget.adsBloc,
                  ),
                  Divider(),
                ],
              ),
            );
        }
      },
    );
  }
}
