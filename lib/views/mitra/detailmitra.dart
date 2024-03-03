import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/shimmer.dart';
import 'package:jagomart/viewmodels/items/items_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/items/items.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailMitraPage extends StatefulWidget {
  final location;
  final title;
  final image;
  final jam;
  final operasional;
  final jarak;
  DetailMitraPage(
      {Key key,
      @required this.location,
      @required this.title,
      @required this.image,
      @required this.jam,
      @required this.jarak,
      @required this.operasional})
      : super(key: key);
  @override
  _DetailMitraPageState createState() => _DetailMitraPageState();
}

class _DetailMitraPageState extends State<DetailMitraPage> {
  bool isLoading = false;
  ScrollController _scrollController;
  int pageCount = 1;
  final itemsBloc = ItemsBloc();

  @override
  void initState() {
    itemsBloc.getItemsMitraTop(1, widget.location);
    super.initState();
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
    bool mitra = await itemsBloc.getItemsMitra(pageCount, widget.location);
    if (!mitra) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverCustomHeaderDelegate(
                  collapsedHeight: 60,
                  coverImgUrl: widget.image,
                  expandedHeight: 220,
                  paddingTop: 20,
                  title: widget.title,
                  operasional: widget.operasional),
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
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  )),
              Container(
                  padding: const EdgeInsets.only(left: 5.0),
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
                        '${widget.title}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "(" + widget.jarak + " km)",
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
                    buildItemsFeature("${widget.operasional}", Themify.home),
                    buildItemsFeature("${widget.jam}", Themify.time),
                    buildItemsFeature("${widget.jarak} km", Themify.map_alt),
                  ],
                ),
              ),
              StreamBuilder(
                  stream: itemsBloc.itemsmitraStream,
                  builder:
                      (context, AsyncSnapshot<List<ItemsViewModel>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            color: Colors.white,
                            child: ShimmerItemVertical(count: 6));
                        break;

                      default:
                        if (snapshot.hasError) {
                          return Container();
                        }

                        return ItemsPage(
                          vi: snapshot.data,
                          isLoading: isLoading,
                          scrollViewController: _scrollController,
                        );
                    }
                  })
            ]))
          ],
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
  final String operasional;

  SliverCustomHeaderDelegate(
      {this.collapsedHeight,
      this.expandedHeight,
      this.paddingTop,
      this.coverImgUrl,
      this.title,
      this.operasional});

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
                        AutoSizeText(
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
