import 'package:flutter/material.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/viewmodels/promo/promo_model.dart';
import 'package:jagomart/viewmodels/promo/promo_view_model.dart';
import 'package:jagomart/views/errorpage.dart';
import 'package:jagomart/views/widget/allpromo.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:themify_flutter/themify_flutter.dart';

class AllPromoPage extends StatefulWidget {
  @override
  _AllPromoPageState createState() => _AllPromoPageState();
}

class _AllPromoPageState extends State<AllPromoPage> {
  final promoBloc = PromoBloc();
  ScrollController _scrollViewController = new ScrollController();
  int currentpage = 1;

  @override
  void initState() {
    promoBloc.getPromoTop(currentpage, Config.nearby);
    _scrollViewController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() async {
    if (_scrollViewController.position.pixels ==
        _scrollViewController.position.maxScrollExtent) {
      currentpage = currentpage + 1;
      promoBloc.getPromo(currentpage, Config.nearby);
    }
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                )
              ], color: Colors.white),
              height: 60.0,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Themify.tag,
                          color: jagoRed,
                          size: 28,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'PROMO',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 18.0, color: jagoRed),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: RefreshIndicator(
                    onRefresh: _refreshpromo,
                    child: SingleChildScrollView(
                        controller: _scrollViewController,
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 15.0),
                              height: 50.0,
                              color: Colors.grey[200],
                              child: Text(
                                'PROMO SEMUA PRODUK',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(
                                        color: Colors.grey[700],
                                        fontSize: 12.0),
                              ),
                            ),
                            StreamBuilder(
                                stream: promoBloc.promoStream,
                                builder: (context,
                                    AsyncSnapshot<List<PromoViewModel>>
                                        snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height -
                                                (kToolbarHeight * 3),
                                        child: Center(
                                            child: Container(
                                          height: 35,
                                          child: LoadingIndicator(
                                            indicatorType:
                                                Indicator.circleStrokeSpin,
                                            color: jagoRed,
                                          ),
                                        )),
                                      );

                                    default:
                                      if (snapshot.hasError) {
                                        return ErrorPage(
                                            MediaQuery.of(context).size.height -
                                                (kToolbarHeight * 2));
                                      }
                                      return AllPromoWidget(vp: snapshot.data);
                                  }
                                }),
                          ],
                        ))))
          ],
        ),
      ),
    );
  }

  Future _refreshpromo() async {
    setState(() {
      currentpage = 1;
    });
    await promoBloc.getPromoTop(currentpage, Config.nearby);
  }
}
