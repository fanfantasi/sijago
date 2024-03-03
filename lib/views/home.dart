import 'package:android_intent_plus/android_intent.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/shimmer.dart';
import 'package:jagomart/viewmodels/ads/ads_view_model.dart';
import 'package:jagomart/viewmodels/items/items_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/items/items.dart';
import 'package:jagomart/views/items/promo.dart';
import 'package:jagomart/views/mitra/mitra.dart';
import 'package:jagomart/views/widget/headers.dart';
import 'package:jagomart/views/widget/kategori.dart';
import 'package:jagomart/views/widget/saldo.dart';
import 'package:jagomart/views/widget/topmenu.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollViewController = new ScrollController();
  double offset = 0.0;
  int currentpage = 1;
  bool isLocationEnabled;
  bool isLoading = true;
  final itemsBloc = ItemsBloc();
  final promoBloc = PromoBloc();
  final mitraBloc = MitraBloc();
  final adsBloc = AdsBloc();

  @override
  void initState() {
    checkService();

    Provider.of<SaldoListViewModel>(context, listen: false).getsaldo();
    Provider.of<BannerListViewModel>(context, listen: false).getbanner();
    Provider.of<KategoriListViewModel>(context, listen: false).getkategori();
    _scrollViewController = ScrollController()..addListener(_scrollListener);
    super.initState();
    () async {
      checklocation().then((value) {
        asyncData();
      });
    }();
  }

  Future<int> checklocation() async {
    var vl;
    if (Config.nearby != '0') {
      vl = int.parse(Config.nearby);
    } else {
      vl = await Provider.of<LokasiListViewModel>(context, listen: false)
          .getlokasi();
    }
    return vl;
  }

  Future<void> asyncData() async {
    await promoBloc.getPromoTop(1, Config.nearby);
    await itemsBloc.getItemsTop(1, Config.nearby);
    await mitraBloc.getMitraTop(1, Config.nearby);
    await adsBloc.getAdsTop(1, 1, Config.nearby);
  }

  void _scrollListener() async {
    if (_scrollViewController.position.pixels ==
        _scrollViewController.position.maxScrollExtent) {
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
    bool items = await itemsBloc.getItems(pageCount, Config.nearby);
    if (!items) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollViewController.removeListener(_scrollListener);
    super.dispose();
  }

  Future<void> checkService() async {
    isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      _showModalSheet();
    }
  }

  void _showModalSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'images/location.gif',
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                      AutoSizeText(
                        'GPS anda tidak aktif.',
                        maxFontSize: 24,
                        style: TextStyle(fontSize: 24),
                      ),
                      FlatButton(
                        onPressed: () async {
                          final AndroidIntent intent = AndroidIntent(
                              action:
                                  'android.settings.LOCATION_SOURCE_SETTINGS');
                          await intent.launch();
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        color: jagoRed,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Aktifkan Sekarang',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    var vs = Provider.of<SaldoListViewModel>(context);
    var vb = Provider.of<BannerListViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: CustomScrollView(
          controller: _scrollViewController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverCustomHeaderDelegateSwiper(
                  collapsedHeight: 60,
                  vb: vb,
                  expandedHeight: 180,
                  paddingTop: 20,
                  title: 'JagoMart',
                  itemsBloc: itemsBloc),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10, top: 10.0),
                child: Column(
                  children: [
                    SaldoWidget(
                      vs: vs,
                    ),
                    TopMenuWidget(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: KategoriWidget(
                  status: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    PromoPage(
                      promoBloc: promoBloc,
                      adsBloc: adsBloc,
                    ),
                    MitraPage(mitraBloc: mitraBloc, adsBloc: adsBloc),
                  ],
                ),
              )
            ])),
            SliverPersistentHeader(
              pinned: true,
              delegate: PersistentHeader("Rekomendasi Buat Kamu"),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              StreamBuilder(
                  stream: itemsBloc.itemsStream,
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
      ),
    );
  }

  Future<void> refreshData() async {
    setState(() {
      Provider.of<SaldoListViewModel>(context, listen: false).getsaldo();
      currentpage = 1;
    });
    await itemsBloc.getItemsTop(currentpage, Config.nearby);
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
