import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/notif.dart';
import 'package:jagomart/views/search/search.dart';
import 'package:jagomart/views/widget/badge.dart';
import 'package:provider/provider.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class SliverCustomHeaderDelegateSwiper extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final BannerListViewModel vb;
  final int index;
  final String title;
  final ItemsBloc itemsBloc;

  SliverCustomHeaderDelegateSwiper({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.vb,
    this.index,
    this.title,
    this.itemsBloc,
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

  Widget _images(BannerListViewModel vb) {
    switch (vb.loadingStatus) {
      case LoadingStatusBanner.searching:
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                  image: AssetImage(
                    'images/no_image.png',
                  ),
                  fit: BoxFit.fitWidth)),
        );
      case LoadingStatusBanner.completed:
        return Swiper(
          autoplay: true,
          itemBuilder: (BuildContext context, int i) {
            return FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: vb.banner[i].photo,
              fit: BoxFit.cover,
            );
          },
          itemCount: vb.banner?.length ?? 0,
          loop: true,
          pagination: new SwiperPagination(
            alignment: Alignment.bottomRight,
          ),
        );
      case LoadingStatusBanner.empty:
      default:
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                  image: AssetImage(
                    'images/no_image.png',
                  ),
                  fit: BoxFit.fitWidth)),
        );
    }
  }

  Widget _location(LokasiListViewModel vl) {
    switch (vl.loadingStatus) {
      case LoadingStatusCabang.searching:
        return AutoSizeText("Loading",
            maxLines: 1, style: GoogleFonts.lato(color: Colors.black54));

      case LoadingStatusCabang.completed:
        return AutoSizeText("${vl.lokasi[0].title}",
            maxLines: 1, style: GoogleFonts.lato(color: Colors.black54));
      case LoadingStatusCabang.empty:
      default:
        return AutoSizeText("Lokasi belum ditentukan",
            maxLines: 1, style: GoogleFonts.lato(color: Colors.black54));
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var vl = Provider.of<LokasiListViewModel>(context);

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
                height: MediaQuery.of(context).size.height / 3.5,
                child: _images(vb)),
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
                    height: 60.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                  height: 60.0,
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
                                  padding: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                  ),
                                  child: FlatButton(
                                      color: Colors.white.withOpacity(.9),
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        side: BorderSide(
                                            color: jagoRed.withOpacity(0.6),
                                            width: 1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _location(vl),
                                          Icon(
                                            Themify.search,
                                            color: jagoRed,
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        push(context, SearchPage());
                                      })),
                            ],
                          ),
                        ),
                        Flexible(
                          child: CircleAvatar(
                              backgroundColor: jagoRed.withOpacity(0.5),
                              child: BadgeWidget()),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              push(context, NotifPage());
                            },
                            child: Badge(
                              badgeContent: null,
                              position: BadgePosition.topEnd(end: 1, top: 1),
                              child: Icon(Icons.notifications,
                                  color: (shrinkOffset <= 50)
                                      ? Colors.white
                                      : jagoRed),
                              badgeColor: Colors.red,
                              animationDuration: Duration(milliseconds: 200),
                              animationType: BadgeAnimationType.scale,
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
