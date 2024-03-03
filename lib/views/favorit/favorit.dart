import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/viewmodels/favorit/favorit_view_model.dart';
import 'package:jagomart/viewmodels/items/items_model.dart';
import 'package:jagomart/viewmodels/lokasi/lokasi_view_model.dart';
import 'package:jagomart/views/items/items.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';

class FavoritPage extends StatefulWidget {
  @override
  _FavoritPageState createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  ScrollController _scrollViewController = new ScrollController();
  bool isLoading = false;
  int currentPage = 1;
  final favoritBloc = FavoritBloc();

  @override
  void initState() {
    _scrollViewController = ScrollController()..addListener(_scrollListener);
    super.initState();
    () async {
      checklocation().then((value) {
        favoritBloc.getFavoritTop(currentPage);
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

  _scrollListener() {
    if (_scrollViewController.offset >=
            _scrollViewController.position.maxScrollExtent &&
        !_scrollViewController.position.outOfRange) {
      setState(() {
        isLoading = true;
      });

      if (isLoading) {
        currentPage = currentPage + 1;
        getData(currentPage);
      }
    }
  }

  void getData(currentPage) async {
    bool news = await favoritBloc.getFavorit(currentPage);
    if (!news) {
      setState(() {
        isLoading = false;
      });
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
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: SafeArea(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                'images/favorite.png',
                                fit: BoxFit.contain,
                                height: 24,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'FAVORIT',
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
                        child: SingleChildScrollView(
                            controller: _scrollViewController,
                            physics: const BouncingScrollPhysics(),
                            child: StreamBuilder(
                                stream: favoritBloc.favoritStream,
                                builder: (context,
                                    AsyncSnapshot<List<ItemsViewModel>>
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
                                        return Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1.5,
                                          child: FlareActor(
                                            "assets/no_favorites.flr",
                                            animation: "Swing",
                                            snapToEnd: false,
                                            fit: BoxFit.fitHeight,
                                            alignment: Alignment.center,
                                          ),
                                        );
                                      }

                                      if (snapshot.data.length == 1) {
                                        return Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1.5,
                                          child: FlareActor(
                                            "assets/no_favorites.flr",
                                            animation: "Swing",
                                            snapToEnd: false,
                                            fit: BoxFit.fitHeight,
                                            alignment: Alignment.center,
                                          ),
                                        );
                                      }
                                      return ItemsPage(
                                        vi: snapshot.data,
                                        isLoading: isLoading,
                                        scrollViewController:
                                            _scrollViewController,
                                      );
                                  }
                                })),
                        onRefresh: _onRefresh),
                  )
                ],
              ),
            )));
  }

  Future<void> _onRefresh() async {
    setState(() {
      currentPage = 1;
    });
    await favoritBloc.getFavorit(currentPage);
  }
}
