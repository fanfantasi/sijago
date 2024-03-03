import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/helpers/shimmer.dart';
import 'package:jagomart/viewmodels/ads/ads_view_model.dart';
import 'package:jagomart/viewmodels/bannercategory/bannercategory_model.dart';
import 'package:jagomart/viewmodels/items/items_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/items/items.dart';
import 'package:jagomart/views/items/promo.dart';
import 'package:jagomart/views/search/search.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class KategoriItemPage extends StatefulWidget {
  final String id;
  final String title;
  KategoriItemPage({@required this.id, @required this.title});
  @override
  _KategoriItemPageState createState() => _KategoriItemPageState();
}

class _KategoriItemPageState extends State<KategoriItemPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollViewController = new ScrollController();
  final itemsBloc = ItemsBloc();
  final promoBloc = PromoBloc();
  final adsBloc = AdsBloc();
  final bannerKategoriBloc = BannerKategoriBloc();
  int currentpage = 1;
  bool isLoading = false;

  @override
  void initState() {
    promoBloc.getPromoTop(currentpage, Config.nearby);
    itemsBloc.getItemsCategoryTop(currentpage, widget.id, Config.nearby);
    bannerKategoriBloc.getBanner(widget.id);
    adsBloc.getAdsTop(1, 2, Config.nearby);
    _scrollViewController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (_scrollViewController.offset >=
            _scrollViewController.position.maxScrollExtent &&
        !_scrollViewController.position.outOfRange) {
      setState(() {
        isLoading = true;
      });

      if (isLoading) {
        currentpage = currentpage + 1;
        getData(currentpage);
      }
    }
  }

  void getData(pageCount) async {
    bool items =
        await itemsBloc.getItemsCategory(pageCount, widget.id, Config.nearby);
    if (!items) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        controller: _scrollViewController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverCustomHeaderDelegate(
                collapsedHeight: kToolbarHeight,
                bannerKategoriBloc: bannerKategoriBloc,
                expandedHeight: 180,
                paddingTop: 20,
                title: widget.title),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            PromoPage(
              promoBloc: promoBloc,
              adsBloc: adsBloc,
            ),
          ])),
          SliverPersistentHeader(
            pinned: false,
            delegate: PersistentHeader(widget.title),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            StreamBuilder(
                stream: itemsBloc.itemscategoryStream,
                builder:
                    (context, AsyncSnapshot<List<ItemsViewModel>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          color: Colors.white,
                          child: ShimmerItemVertical(count: 12));
                      break;

                    default:
                      if (snapshot.hasError) {
                        return Container();
                      }

                      return ItemsPage(
                        vi: snapshot.data,
                        isLoading: isLoading,
                        scrollViewController: _scrollViewController,
                      );
                  }
                })
          ]))
        ],
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
      padding: const EdgeInsets.only(top: 10.0, left: 10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
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
  double get maxExtent => 50.0;

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
  final BannerKategoriBloc bannerKategoriBloc;
  final String title;

  SliverCustomHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.bannerKategoriBloc,
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
            StreamBuilder(
                stream: bannerKategoriBloc.bannerStream,
                builder: (context,
                    AsyncSnapshot<List<BannerCategoryViewModel>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                        height: MediaQuery.of(context).size.height / 4.7,
                        child: Swiper(
                            autoplay: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                          'images/no_image.png',
                                        ),
                                        fit: BoxFit.fitWidth)),
                              );
                            },
                            itemCount: 3,
                            pagination: new SwiperPagination(
                              alignment: Alignment.bottomLeft,
                            ),
                            control: new SwiperControl(
                              iconNext: Themify.arrow_circle_right,
                              size: 14,
                              iconPrevious: Themify.arrow_circle_left,
                            )),
                      );
                      break;
                    default:
                      if (snapshot.hasError) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 4.7,
                          child: Swiper(
                              autoplay: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                            'images/no_image.png',
                                          ),
                                          fit: BoxFit.fitWidth)),
                                );
                              },
                              itemCount: 3,
                              pagination: new SwiperPagination(
                                alignment: Alignment.bottomLeft,
                              ),
                              control: new SwiperControl(
                                iconNext: Themify.arrow_circle_right,
                                size: 14,
                                iconPrevious: Themify.arrow_circle_left,
                              )),
                        );
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height / 4.7,
                        child: Swiper(
                            autoplay: true,
                            itemBuilder: (BuildContext context, int index) {
                              return FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: snapshot.data[index].photo,
                                fit: BoxFit.fill,
                              );
                            },
                            itemCount: snapshot.data?.length ?? 0,
                            pagination: new SwiperPagination(
                              alignment: Alignment.bottomLeft,
                            ),
                            control: new SwiperControl(
                              iconNext: Themify.arrow_circle_right,
                              size: 14,
                              iconPrevious: Themify.arrow_circle_left,
                            )),
                      );
                  }
                }),
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
                          backgroundColor: Colors.grey.withOpacity(0.4),
                          child: IconButton(
                              icon: Icon(
                                Themify.search,
                                color: this.makeStickyHeaderTextColor(
                                    shrinkOffset, true),
                              ),
                              onPressed: () {
                                push(context, SearchPage());
                              }),
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
