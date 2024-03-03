import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/helpers/zoomimage.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/cart/cart.dart';
import 'package:jagomart/views/items/related.dart';
import 'package:jagomart/views/items/ulasan.dart';
import 'package:jagomart/views/widget/badge.dart';
import 'package:jagomart/views/widget/favorit.dart';
import 'package:jagomart/views/widget/tags.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:jagomart/views/mitra/detailmitra.dart';

class DetailPage extends StatefulWidget {
  final vi;
  final int index;
  DetailPage({@required this.vi, @required this.index});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ulasanBloc = UlasanBloc();
  final favoritBloc = FavoritBloc();

  bool isLoading;
  @override
  void initState() {
    ulasanBloc.getUlasan(widget.vi.id);
    favoritBloc.getFavoritByid(widget.vi.id, false);
    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: isLoading ? true : false,
        progressIndicator: Container(
          width: 65,
          height: 65,
          padding: EdgeInsets.all(12.0),
          child: LoadingIndicator(
              color: jagoRed, indicatorType: Indicator.circleStrokeSpin),
        ),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverCustomHeaderDelegate(
                  collapsedHeight: 60,
                  coverImgUrl: widget.vi.images,
                  index: widget.index,
                  expandedHeight: 220,
                  paddingTop: 20,
                  title: widget.vi.item),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: AutoSizeText(
                          '${widget.vi.item}',
                          maxLines: 1,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: FavoritWidget(favoritBloc, widget.vi.id))
                    ],
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
                        '${widget.vi.mitra}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "(" + widget.vi.distance + " km)",
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
                    buildItemsFeature("${widget.vi.operasional}",
                        widget.vi.operasionalstatus, Themify.home),
                    buildItemsFeature("${widget.vi.jamoperasional}",
                        widget.vi.operasionalstatus, Themify.time),
                    buildItemsFeature("${widget.vi.distance} km",
                        widget.vi.operasionalstatus, Themify.map_alt),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  height: 15.0,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        (widget.vi.rating[0].rating == null)
                            ? '0.0'
                            : '${widget.vi.rating[0].rating.toStringAsFixed(2)}',
                        style:
                            TextStyle(color: Colors.deepOrange, fontSize: 12.0),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "${widget.vi.rating[0].sumrating} Review",
                        style:
                            TextStyle(color: Colors.deepOrange, fontSize: 10.0),
                      )
                    ],
                  )),
              Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  height: 22.0,
                  margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                  child: (widget.vi.disc == null)
                      ? AutoSizeText('Rp. ${formatter.format(widget.vi.price)}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          maxFontSize: 22,
                          style: GoogleFonts.lato(
                              fontSize: 18.0, fontWeight: FontWeight.bold))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                                'Rp. ${formatter.format(widget.vi.pricedisc)}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                maxFontSize: 22,
                                style: GoogleFonts.lato(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            AutoSizeText(
                                'Rp. ${formatter.format(widget.vi.price)}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                maxFontSize: 22,
                                style: GoogleFonts.lato(
                                    fontSize: 18.0,
                                    color: Colors.black38,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 2,
                                    decorationColor: Colors.black38,
                                    decorationStyle:
                                        TextDecorationStyle.double)),
                          ],
                        )),
              Padding(
                padding: EdgeInsets.only(right: 16, left: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildFilter("${widget.vi.kategori}", false),
                    buildFilter("${widget.vi.group}", true),
                  ],
                ),
              ),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: RelatedPage(
                  tags: widget.vi.tags,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                            child: AutoSizeText("Ulasan",
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
                    ],
                  )),
            ])),
            UlasanPage(ulasanBloc: ulasanBloc)
          ],
        ),
      ),
      bottomNavigationBar: Consumer<CartListViewModel>(
        builder: (context, vb, _) {
          return Container(
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
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: jagoRed),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Themify.home, color: jagoRed, size: 16),
                          Text("Toko", style: GoogleFonts.lato(fontSize: 13)),
                        ],
                      ),
                      onPressed: () {
                        push(
                            context,
                            DetailMitraPage(
                                location: widget.vi.mitraid,
                                title: widget.vi.mitra,
                                image: widget.vi.mitraimage,
                                jam: widget.vi.jamoperasional,
                                jarak: widget.vi.distance,
                                operasional: widget.vi.operasional));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                  child: Container(
                    height: 40,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: jagoRed),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Themify.plus,
                            color: jagoRed,
                            size: 16,
                          ),
                          Text("Beli", style: GoogleFonts.lato(fontSize: 13)),
                        ],
                      ),
                      onPressed: () async {
                        if (!widget.vi.operasionalstatus) {
                          SweetAlert.show(context,
                              title: "Informasi",
                              subtitle: "${widget.vi.mitra} Sudah Tutup.",
                              confirmButtonColor: jagoRed,
                              style: SweetAlertStyle.error);
                        } else if (widget.vi.stock == 2) {
                          SweetAlert.show(context,
                              title: "Informasi",
                              subtitle: "Stock Kami Sudah Habis.",
                              confirmButtonColor: jagoRed,
                              style: SweetAlertStyle.error);
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          Future.delayed(Duration(milliseconds: 200), () async {
                            await vb.addCart(
                                int.parse(widget.vi.id),
                                widget.vi.item,
                                widget.vi.unit,
                                widget.vi.disc,
                                widget.vi.price,
                                widget.vi.pricedisc,
                                widget.vi.images[0].image,
                                '${widget.vi.location.latitude},${widget.vi.location.longitude}');
                            setState(() {
                              isLoading = false;
                            });
                            push(context, CartPage());
                          });
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.white24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Themify.shopping_cart, color: Colors.white),
                          Flexible(
                            // width: MediaQuery.of(context).size.width / 3,
                            child: AutoSizeText("Tambah Ke Keranjang",
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                maxFontSize: 14,
                                style: GoogleFonts.lato(color: Colors.white)),
                          ),
                        ],
                      ),
                      color: jagoRed,
                      onPressed: () {
                        if (!widget.vi.operasionalstatus) {
                          SweetAlert.show(context,
                              title: "Informasi",
                              subtitle: "${widget.vi.mitra} Sudah Tutup.",
                              confirmButtonColor: jagoRed,
                              style: SweetAlertStyle.error);
                        } else if (widget.vi.stock == 2) {
                          SweetAlert.show(context,
                              title: "Informasi",
                              subtitle: "Stock Kami Sudah Habis.",
                              confirmButtonColor: jagoRed,
                              style: SweetAlertStyle.error);
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          Future.delayed(Duration(milliseconds: 200), () async {
                            await vb.addCart(
                                int.parse(widget.vi.id),
                                widget.vi.item,
                                widget.vi.unit,
                                widget.vi.disc,
                                widget.vi.price,
                                widget.vi.pricedisc,
                                widget.vi.images[0].image,
                                '${widget.vi.location.latitude},${widget.vi.location.longitude}');
                            setState(() {
                              isLoading = false;
                            });
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final String title;

  PersistentHeader(this.title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
      child: Container(
        height: 75,
        width: double.infinity,
        margin: const EdgeInsets.all(5.0),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 3,
                height: 20,
                color: (shrinkOffset == 0.0) ? jagoRed : Colors.black87,
              ),
              SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: AutoSizeText("$title",
                    maxLines: 1,
                    maxFontSize: 22,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.lato(
                        color: (shrinkOffset == 0.0) ? Colors.black87 : jagoRed,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  @override
  double get maxExtent => 40.0;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final coverImgUrl;
  final int index;
  final String title;

  SliverCustomHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.coverImgUrl,
    this.index,
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (shrinkOffset <= 50)
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Container(
        height: this.maxExtent,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 4.7,
              child: Swiper(
                autoplay: true,
                itemBuilder: (BuildContext context, int i) {
                  return GestureDetector(
                    onTap: () {
                      pushTransparant(
                          context,
                          ZoomImage(
                              imageProvider: NetworkImage(coverImgUrl[i].image),
                              tags: 'zoom' + coverImgUrl[i].id));
                    },
                    child: Hero(
                        tag: 'zoom' + coverImgUrl[i].id,
                        transitionOnUserGestures: true,
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: coverImgUrl[i].image,
                          fit: BoxFit.cover,
                        )),
                  );
                },
                itemCount: coverImgUrl?.length ?? 0,
                loop: false,
                pagination: new SwiperPagination(
                  alignment: Alignment.bottomLeft,
                ),
                control: new SwiperControl(
                    iconNext: Themify.arrow_circle_right,
                    size: 14,
                    iconPrevious: Themify.arrow_circle_left,
                    color: Colors.white),
              ),
            ),
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
                        CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.8),
                            child: BadgeWidget()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
