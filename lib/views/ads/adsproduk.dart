import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:jagomart/helpers/shimmer.dart';
import 'package:jagomart/viewmodels/adsitems/adsitems_model.dart';
import 'package:jagomart/viewmodels/adsitems/adsitems_view_model.dart';
import 'package:jagomart/views/ads/produk.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:jagomart/views/widget/background.dart';
import 'package:transparent_image/transparent_image.dart';

class AdsProdukPage extends StatefulWidget {
  final id;
  final image;
  final title;
  final distance;
  final phone;
  AdsProdukPage({
    Key key,
    @required this.id,
    @required this.image,
    @required this.title,
    @required this.distance,
    @required this.phone,
  }) : super(key: key);
  @override
  _AdsProdukPageState createState() => _AdsProdukPageState();
}

class _AdsProdukPageState extends State<AdsProdukPage> {
  bool isLoading = false;
  ScrollController _scrollController;
  final adsItemsBloc = AdsItemsBloc();
  int pageCount = 1;

  @override
  void initState() {
    super.initState();
    adsItemsBloc.getAdsItemsTop(pageCount, widget.id);
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
    await adsItemsBloc.getAds(pageCount, widget.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Background(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverCustomHeaderDelegate(
                    collapsedHeight: 60,
                    coverImgUrl: widget.image,
                    expandedHeight: 160,
                    paddingTop: 20,
                    title: widget.title),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 10.0),
                    child: AutoSizeText(
                      '${widget.title}',
                      maxLines: 1,
                      style: GoogleFonts.lato(
                          fontSize: 22,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    )),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      buildItemsFeature("${widget.phone}", Themify.mobile),
                      buildItemsFeature(
                          "${widget.distance} km", Themify.map_alt),
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: adsItemsBloc.adsItemsStream,
                    builder: (context,
                        AsyncSnapshot<List<AdsItemsViewModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              color: Colors.white,
                              child: ShimmerItemHorizontalList(count: 3));
                          break;

                        default:
                          if (snapshot.hasError) {
                            return Container();
                          }

                          return ProdukAdsWidget(
                            isLoading: isLoading,
                            phone: widget.phone,
                            vi: snapshot.data,
                            scrollViewController: _scrollController,
                            distance: widget.distance,
                            title: widget.title,
                          );
                      }
                    })
              ]))
            ],
          ),
        ));
  }

  buildItemsFeature(String value, IconData icon) {
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
                  color: Colors.green, fontWeight: FontWeight.bold),
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

  SliverCustomHeaderDelegate(
      {this.collapsedHeight,
      this.expandedHeight,
      this.paddingTop,
      this.coverImgUrl,
      this.title});

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
                height: MediaQuery.of(context).size.height / 4.9,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: coverImgUrl,
                  fit: BoxFit.fill,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          width: MediaQuery.of(context).size.width / 1.5,
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
      ),
    );
  }
}
