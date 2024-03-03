import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/shimmer.dart';
import 'package:jagomart/viewmodels/related/related_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/widget/related.dart';

import 'package:jagomart/config/koneksi.dart';

class RelatedPage extends StatefulWidget {
  final String tags;
  RelatedPage({Key key, @required this.tags}) : super(key: key);

  @override
  _RelatedPageState createState() => _RelatedPageState();
}

class _RelatedPageState extends State<RelatedPage> {
  final relatedBloc = RelatedBloc();

  @override
  void initState() {
    relatedBloc.getRelatedTop(1, Config.nearby, widget.tags);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: relatedBloc.relatedStream,
      builder: (context, AsyncSnapshot<List<RelatedViewModel>> snapshot) {
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
                      child: AutoSizeText("Produk Serupa",
                          maxLines: 1,
                          maxFontSize: 22,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.lato(
                              color: Colors.black87,
                              fontSize: 16,
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

            return Container(
              color: Colors.white,
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
                        child: AutoSizeText("Produk Serupa",
                            maxLines: 1,
                            maxFontSize: 22,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.lato(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  RelatedWidget(
                    vp: snapshot.data,
                  )
                ],
              ),
            );
        }
      },
    );
  }
}
