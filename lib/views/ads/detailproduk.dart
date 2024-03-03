import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/viewmodels/adsitems/adsitems_model.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailProdukAds extends StatefulWidget {
  final AdsItemsViewModel vi;
  final distance;
  final title;
  final phone;
  DetailProdukAds(
      {@required this.vi,
      @required this.distance,
      @required this.title,
      @required this.phone});

  @override
  _DetailProdukAdsState createState() => _DetailProdukAdsState();
}

class _DetailProdukAdsState extends State<DetailProdukAds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverCustomHeaderDelegate(
                collapsedHeight: 60,
                coverImgUrl: widget.vi.image,
                expandedHeight: 220,
                paddingTop: 20,
                title: widget.vi.title),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: AutoSizeText(
                  '${widget.vi.title}',
                  maxLines: 1,
                  style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                )),
            Container(
                padding: const EdgeInsets.only(top: 10, left: 10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "(" + widget.distance + " km)",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  buildItemsFeature("${widget.vi.stock}", false, Themify.home),
                  buildItemsFeature(
                      "${widget.vi.jenis}", false, Themify.shopping_cart),
                  buildItemsFeature(
                      "${widget.distance} km", false, Themify.map_alt),
                ],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width / 2.2,
                height: 22.0,
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                child: AutoSizeText('Rp. ${formatter.format(widget.vi.price)}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    maxFontSize: 22,
                    style: GoogleFonts.lato(
                        fontSize: 18.0, fontWeight: FontWeight.bold))),
            Divider(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Deskripsi",
                        style: GoogleFonts.lato(
                            fontSize: 16.0, fontWeight: FontWeight.w900)),
                    Html(
                      data: widget.vi.desc,
                    ),
                  ],
                )),
          ]))
        ]),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                    child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2.1,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: jagoRed),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Themify.mobile, color: jagoRed, size: 16),
                              Text("Telepon",
                                  style: GoogleFonts.lato(fontSize: 13)),
                            ],
                          ),
                          onPressed: () async {
                            await FlutterPhoneDirectCaller.callNumber(
                                widget.phone);
                          },
                        ))),
                Padding(
                    padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                    child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2.1,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: jagoRed),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Themify.email, color: jagoGreen, size: 16),
                              Text("Whatsapp",
                                  style: GoogleFonts.lato(fontSize: 13)),
                            ],
                          ),
                          onPressed: () {
                            FlutterOpenWhatsapp.sendSingleMessage(
                                "${widget.phone}", "Hallo Kak.");
                          },
                        )))
              ],
            )));
  }

  buildItemsFeature(String value, bool feature, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[200],
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.black54,
              size: 16,
            ),
            SizedBox(
              height: 5,
            ),
            AutoSizeText(
              value,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  color: Formatter.warnaoperasional(feature),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final coverImgUrl;
  final String title;

  SliverCustomHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.coverImgUrl,
    this.title,
  });

  @override
  double get minExtent => this.collapsedHeight + this.paddingTop;

  @override
  double get maxExtent => this.expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  Color makeStickyHeaderBgColor(shrinkOffset) {
    final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255)
        .clamp(0, 255)
        .toInt();
    return Color.fromARGB(alpha, 255, 255, 255);
  }

  Color makeStickyHeaderTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255)
          .clamp(0, 255)
          .toInt();
      return Color.fromARGB(alpha, 0, 0, 0);
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: this.maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height / 4.7,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: coverImgUrl,
                fit: BoxFit.cover,
              )),
          // Put your head back
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: this
                  .makeStickyHeaderBgColor(shrinkOffset), // Background color
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: this.collapsedHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: this.makeStickyHeaderTextColor(
                              shrinkOffset, true), // Return icon color
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: AutoSizeText(
                          this.title,
                          maxFontSize: 16,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: this.makeStickyHeaderTextColor(
                                shrinkOffset, false), // Title color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
