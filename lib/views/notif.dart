import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/date_util.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/notif/notif_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/errorpage.dart';
import 'package:jagomart/views/pesanan/pesanan.dart';
import 'package:jagomart/views/promo/allpromo.dart';
import 'package:jagomart/views/signout.dart';
import 'package:jagomart/views/tracking/tracking.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:themify_flutter/themify_flutter.dart';

class NotifPage extends StatefulWidget {
  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  ScrollController _scrollViewController = new ScrollController();
  final notifBloc = NotifBloc();
  bool isLoading = false;
  int currentPage = 1;

  @override
  void initState() {
    notifBloc.getNotifTop(currentPage);
    _scrollViewController = ScrollController()..addListener(_scrollListener);
    super.initState();
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

  void getData(pageCount) async {
    bool mitra = await notifBloc.getNotif(pageCount);
    if (!mitra) {
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

  Widget _pages(AuthListViewModel vs) {
    switch (vs.loadingStatus) {
      case LoadingStatusAuth.signout:
        return SignOutPage();
      case LoadingStatusAuth.signin:
        return _notif();

      default:
        return SignOutPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    var va = Provider.of<AuthListViewModel>(context);
    return Scaffold(body: _pages(va));
  }

  Widget _notif() {
    return SafeArea(
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
                      Icon(
                        Themify.bell,
                        color: jagoRed,
                        size: 24,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'NOTIFIKASI',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 18.0, color: jagoRed),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: InkWell(
                      onTap: () {
                        _refreshNotif();
                      },
                      child: Icon(
                        Themify.reload,
                        color: jagoRed,
                      ),
                    ))
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15.0),
            height: 50.0,
            color: Colors.grey[200],
            child: Text(
              'NOTIFIKASI',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Colors.grey[700], fontSize: 12.0),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
                onRefresh: _refreshNotif,
                child: SingleChildScrollView(
                  controller: _scrollViewController,
                  physics: BouncingScrollPhysics(),
                  child: StreamBuilder(
                      stream: notifBloc.notifStream,
                      builder: (context,
                          AsyncSnapshot<List<NotifViewModel>> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                              height: MediaQuery.of(context).size.height -
                                  (kToolbarHeight * 3),
                              child: Center(
                                  child: Container(
                                height: 35,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.circleStrokeSpin,
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
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length + 1,
                              itemBuilder: (context, i) {
                                if (i == snapshot.data.length) {
                                  if (isLoading) {
                                    return Container(
                                      height: 100,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                }

                                if (i == snapshot.data.length) {
                                  return InkWell(
                                    onTap: () {
                                      _scrollViewController.animateTo((0.0 * i),
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeOut);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      width: double.infinity,
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Icon(
                                            Themify.angle_double_up,
                                            color: Colors.grey,
                                            size: 24,
                                          ),
                                          AutoSizeText(
                                              'Batas Akhir Notifikasi Si Jago',
                                              maxLines: 2,
                                              overflow: TextOverflow.fade,
                                              style: GoogleFonts.acme(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 1.0,
                                                    color: Colors.black54,
                                                    offset: Offset(1.0, 1.0),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                if (snapshot.data.length < 1) {
                                  return Container(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    width: double.infinity,
                                    height: 100,
                                    child: Column(
                                      children: [
                                        Icon(
                                          Themify.angle_double_up,
                                          color: Colors.grey,
                                          size: 24,
                                        ),
                                        AutoSizeText('Data Masih Kosong',
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                            style: GoogleFonts.acme(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 1.0,
                                                  color: Colors.black54,
                                                  offset: Offset(1.0, 1.0),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  );
                                }

                                return Column(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: BoxDecoration(
                                            color: (snapshot.data[i].read == 1)
                                                ? Colors.black12
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                                color: Colors.black12)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: InkWell(
                                          onTap: () {
                                            switch (snapshot.data[i].status) {
                                              case 1:
                                                // globalProv.updatednotif(widget.list.id);
                                                return push(
                                                    context,
                                                    PesananPage(
                                                      title:
                                                          'Invoice Transaksi',
                                                      transid: snapshot
                                                          .data[i].notifid,
                                                    ));
                                                break;

                                              case 2:
                                                // globalProv.updatednotif(widget.list.id);
                                                return push(
                                                    context,
                                                    TrackingPage(
                                                      title:
                                                          'Tracking Pesanan Anda',
                                                      transid: snapshot
                                                          .data[i].notifid,
                                                    ));
                                                break;

                                              case 4:
                                              // globalProv.updatednotif(widget.list.id);
                                              // return push(
                                              //     context,
                                              //     InvoicePulsaScreen(
                                              //       title: 'Invoice Transaksi',
                                              //       transid: widget.list.notifid,
                                              //     ));

                                              case 6:
                                                // globalProv.updatednotif(widget.list.id);
                                                return push(
                                                    context, AllPromoPage());
                                                break;

                                              case 9:
                                                // globalProv.updatednotif(widget.list.id);
                                                SweetAlert.show(
                                                  context,
                                                  title:
                                                      "${snapshot.data[i].title}",
                                                  subtitle:
                                                      "${snapshot.data[i].message}",
                                                  confirmButtonColor: jagoRed,
                                                );
                                                break;
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'images/logo.png',
                                                  width: 35,
                                                  height: 35,
                                                ),
                                                SizedBox(
                                                  width: 4.0,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AutoSizeText(
                                                        '${snapshot.data[i].title}',
                                                        maxFontSize: 14,
                                                        minFontSize: 12,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      AutoSizeText(
                                                        '${snapshot.data[i].message}',
                                                        maxFontSize: 14,
                                                        minFontSize: 12,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Themify.time,
                                                            color: Colors.green,
                                                            size: 16,
                                                          ),
                                                          SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              "${tanggal(DateTime.parse(snapshot.data[i].created))}",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ),
                                                          Icon(
                                                              (snapshot.data[i]
                                                                          .read ==
                                                                      1)
                                                                  ? Themify.bell
                                                                  : Themify
                                                                      .layout_media_right,
                                                              color:
                                                                  Colors.green),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                    Divider(),
                                  ],
                                );
                              },
                            );
                        }
                      }),
                )),
          )
        ],
      ),
    );
  }

  Future _refreshNotif() async {
    setState(() {
      currentPage = 1;
      isLoading = true;
    });
    var notif = await notifBloc.getNotifTop(currentPage);
    if (!notif) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
