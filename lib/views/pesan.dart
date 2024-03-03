import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/custom_divider_view.dart';
import 'package:jagomart/helpers/date_util.dart';
import 'package:jagomart/helpers/dotted_seperator_view.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/order/order_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/pesanan/pesanan.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:jagomart/views/pesanan/review.dart';

class PesanPage extends StatefulWidget {
  @override
  _PesanPageState createState() => _PesanPageState();
}

class _PesanPageState extends State<PesanPage> {
  ScrollController _scrollViewController = new ScrollController();
  int currentPage = 1;

  final orderBloc = OrderBloc();
  bool load = false;

  @override
  void initState() {
    orderBloc.getHistorytop(currentPage);
    _scrollViewController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollViewController.offset >=
            _scrollViewController.position.maxScrollExtent &&
        !_scrollViewController.position.outOfRange) {
      setState(() {
        load = true;
      });

      if (load) {
        currentPage = currentPage + 1;
        getData(currentPage);
      }
    }
  }

  void getData(pageCount) async {
    bool mitra = await orderBloc.getHistory(pageCount);
    if (!mitra) {
      setState(() {
        load = false;
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'images/cart.png',
                          fit: BoxFit.contain,
                          height: 24,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'History Pesanan',
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
                          _refresh();
                        },
                        child: Icon(
                          Themify.reload,
                          color: jagoRed,
                        ),
                      ))
                ],
              ),
            ),
            Expanded(
                child: RefreshIndicator(
              onRefresh: _refresh,
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
                          'DAFTAR BELANJAAN ANDA',
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Colors.grey[700], fontSize: 12.0),
                        ),
                      ),
                      StreamBuilder<List<OrderViewModel>>(
                          stream: orderBloc.historyStream,
                          builder: (context, AsyncSnapshot snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Container(
                                  height: MediaQuery.of(context).size.height -
                                      (kToolbarHeight * 3),
                                  child: Center(
                                      child: Container(
                                    height: 35,
                                    width: 35,
                                    child: LoadingIndicator(
                                      indicatorType: Indicator.circleStrokeSpin,
                                      color: jagoRed,
                                    ),
                                  )),
                                );
                                break;

                              default:
                                if (snapshot.hasError) {
                                  return Container();
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.length + 1,
                                  itemBuilder: (context, i) {
                                    if (i == snapshot.data.length) {
                                      if (load) {
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
                                          _scrollViewController.animateTo(
                                              (0.0 * i),
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeOut);
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
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
                                                  'Batas Akhir Pesanan dari Si Jago',
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
                                                        offset:
                                                            Offset(1.0, 1.0),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                      );
                                    }

                                    return Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 15.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            AutoSizeText(
                                                              '${snapshot.data[i].transid}',
                                                              maxFontSize: 14,
                                                              minFontSize: 10,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14.0),
                                                            ),
                                                            SizedBox(
                                                              width: 5.0,
                                                            ),
                                                            InkWell(
                                                              child: Icon(
                                                                Icons
                                                                    .content_copy,
                                                                color:
                                                                    Colors.grey,
                                                                size: 16,
                                                              ),
                                                              onTap: () {
                                                                Clipboard.setData(
                                                                    new ClipboardData(
                                                                        text:
                                                                            '${snapshot.data[i].transid}'));
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        'No. Transaksi Telah Disalin',
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    gravity:
                                                                        ToastGravity
                                                                            .BOTTOM,
                                                                    backgroundColor: Theme
                                                                            .of(
                                                                                context)
                                                                        .primaryColor
                                                                        .withOpacity(
                                                                            0.7),
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    fontSize:
                                                                        14.0);
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        AutoSizeText(
                                                            '${Formatter.payment(snapshot.data[i].paystatus)}',
                                                            maxFontSize: 14,
                                                            maxLines: 1,
                                                            minFontSize: 10,
                                                            style: GoogleFonts
                                                                .lato()),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Image.network(
                                                              snapshot
                                                                  .data[i].icon,
                                                              scale: 10,
                                                            ),
                                                            SizedBox(
                                                              width: 5.0,
                                                            ),
                                                            AutoSizeText(
                                                                '${snapshot.data[i].payment}'),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Container(
                                                          // width: MediaQuery.of(context).size.width / 2,
                                                          child: AutoSizeText(
                                                            '${Formatter.status(snapshot.data[i].status)}',
                                                            maxFontSize: 14,
                                                            minFontSize: 10,
                                                            style: TextStyle(
                                                              color: Formatter
                                                                  .warna(snapshot
                                                                      .data[i]
                                                                      .status),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        ClipOval(
                                                            child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.2),
                                                          color:
                                                              Formatter.warna(
                                                                  snapshot
                                                                      .data[i]
                                                                      .status),
                                                          child: Icon(
                                                              Formatter
                                                                  .icontransaksi(
                                                                      snapshot
                                                                          .data[
                                                                              i]
                                                                          .status),
                                                              color:
                                                                  Colors.white,
                                                              size: 14.0),
                                                        ))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              AutoSizeText(
                                                '${snapshot.data[i].remarks}',
                                                maxFontSize: 14,
                                                minFontSize: 10,
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                              DottedSeperatorView(),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  AutoSizeText(
                                                      '${tanggal(DateTime.parse(snapshot.data[i].datetrans))}'),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: (snapshot.data[i]
                                                                    .status ==
                                                                5)
                                                            ? Container()
                                                            : (snapshot.data[i]
                                                                        .statusdone ==
                                                                    0)
                                                                ? Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .stretch,
                                                                      children: <
                                                                          Widget>[
                                                                        OutlineButton(
                                                                          color:
                                                                              jagoRed,
                                                                          borderSide: BorderSide(
                                                                              width: 0.5,
                                                                              color: Colors.black),
                                                                          child: Text(
                                                                              'Konfirmasi',
                                                                              style: GoogleFonts.lato()),
                                                                          onPressed:
                                                                              () {
                                                                            (snapshot.data[i].paystatus == 1 && snapshot.data[i].methodstatus == 0)
                                                                                ? _navigateKonfirmasi(context)
                                                                                : SweetAlert.show(context, subtitle: "Konfirmasi Barang", style: SweetAlertStyle.confirm, cancelButtonText: 'Tidak', confirmButtonText: 'Ya', confirmButtonColor: jagoRed, showCancelButton: true, onPress: (bool isConfirm) {
                                                                                    if (isConfirm) {
                                                                                      if (snapshot.data[i].driverid != 0) {
                                                                                        SweetAlert.show(context, subtitle: "Konfirmasi Barang...", style: SweetAlertStyle.loading);
                                                                                        new Future.delayed(new Duration(milliseconds: 200), () async {
                                                                                          await orderBloc.confirmorder(snapshot.data[i].transid, snapshot.data[i].ongkir, snapshot.data[i].driverid);
                                                                                          if (orderBloc.aksi[0].status == true) {
                                                                                            SweetAlert.show(context, subtitle: "Sukses!", style: SweetAlertStyle.success, confirmButtonColor: jagoRed, onPress: (bool isConfirm) {
                                                                                              orderBloc.getHistorytop(1);
                                                                                              return null;
                                                                                            });
                                                                                          } else {
                                                                                            SweetAlert.show(context, subtitle: "Error!", style: SweetAlertStyle.error, confirmButtonColor: jagoRed, onPress: (bool isConfirm) {
                                                                                              return null;
                                                                                            });
                                                                                          }
                                                                                        });
                                                                                      } else {
                                                                                        SweetAlert.show(
                                                                                          context,
                                                                                          title: 'Sabar ya Kak.',
                                                                                          subtitle: "Driver kami belum siap!",
                                                                                          style: SweetAlertStyle.error,
                                                                                          confirmButtonColor: jagoRed,
                                                                                        );
                                                                                      }
                                                                                    } else {
                                                                                      SweetAlert.show(
                                                                                        context,
                                                                                        subtitle: "Kenapa Kak!",
                                                                                        style: SweetAlertStyle.error,
                                                                                        confirmButtonColor: jagoRed,
                                                                                      );
                                                                                    }
                                                                                    return false;
                                                                                  });
                                                                          },
                                                                        ),
                                                                        (snapshot.data[i].paystatus == 1 &&
                                                                                snapshot.data[i].methodstatus == 0)
                                                                            ? AutoSizeText(
                                                                                "Mohon segera melakukan pembayaran sesuai dengan methode pembayaran yang anda pilih.",
                                                                                maxFontSize: 12,
                                                                                minFontSize: 12,
                                                                                maxLines: 2,
                                                                                style: GoogleFonts.lato(),
                                                                                overflow: TextOverflow.ellipsis,
                                                                              )
                                                                            : AutoSizeText(
                                                                                "Mohon konfirmasi apabila pesanan sudah sampai.",
                                                                                maxFontSize: 12,
                                                                                minFontSize: 12,
                                                                                maxLines: 2,
                                                                                style: GoogleFonts.lato(color: Colors.green),
                                                                                overflow: TextOverflow.ellipsis,
                                                                              )
                                                                      ],
                                                                    ) ??
                                                                    (snapshot
                                                                            .data[
                                                                                i]
                                                                            .review ==
                                                                        1)
                                                                : (snapshot.data[i]
                                                                            .review ==
                                                                        1)
                                                                    ? Container()
                                                                    : Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.stretch,
                                                                        children: <
                                                                            Widget>[
                                                                          OutlineButton(
                                                                              color: jagoRed,
                                                                              borderSide: BorderSide(width: 0.5, color: Colors.green),
                                                                              child: Text(
                                                                                'Review',
                                                                                style: GoogleFonts.lato(),
                                                                              ),
                                                                              onPressed: () {
                                                                                _navigateReview(context, snapshot.data[i]);
                                                                              }),
                                                                          AutoSizeText(
                                                                            'Review produk yang telah dibelinya dong kak.',
                                                                            maxFontSize:
                                                                                12,
                                                                            minFontSize:
                                                                                10,
                                                                            maxLines:
                                                                                2,
                                                                            style:
                                                                                GoogleFonts.lato(),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          )
                                                                        ],
                                                                      ),
                                                      ),
                                                      SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: <Widget>[
                                                            OutlineButton(
                                                              color:
                                                                  jagodarkRed,
                                                              borderSide:
                                                                  BorderSide(
                                                                      width:
                                                                          0.5,
                                                                      color:
                                                                          jagodarkRed),
                                                              child:
                                                                  AutoSizeText(
                                                                'Detail Pesanan',
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(),
                                                              ),
                                                              onPressed: () {
                                                                push(
                                                                    context,
                                                                    PesananPage(
                                                                        title:
                                                                            'Pesanan Anda',
                                                                        transid: snapshot
                                                                            .data[i]
                                                                            .transid));
                                                              },
                                                            ),
                                                            AutoSizeText(
                                                              'Untuk selengkapnya lihat detail pesanan anda disini',
                                                              maxFontSize: 12,
                                                              minFontSize: 10,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        CustomDividerView(
                                            dividerHeight: 10,
                                            color: Colors.grey[200])
                                      ],
                                    );
                                  },
                                );
                            }
                          })
                    ],
                  )),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      load = true;
      currentPage = 1;
    });
    var order = await orderBloc.getHistorytop(currentPage);
    if (!order)
      setState(() {
        load = false;
      });
  }

  _navigateKonfirmasi(BuildContext context) async {}

  _navigateReview(BuildContext context, OrderViewModel vo) async {
    final result = Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => ReviewPage(
          vo: vo,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        currentPage = 1;
      });
      await orderBloc.getHistorytop(currentPage);
    }
  }
}
