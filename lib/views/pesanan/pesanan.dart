import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/date_util.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/helpers/customClipper.dart';
import 'package:jagomart/helpers/shimmer.dart';
import 'package:jagomart/viewmodels/order/order_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/tracking/tracking.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:ticket_pass_package/ticket_pass.dart';

class PesananPage extends StatefulWidget {
  final title;
  final String transid;
  PesananPage({Key key, @required this.title, @required this.transid})
      : super(key: key);
  @override
  _PesananPageState createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  final orderBloc = OrderBloc();
  @override
  void initState() {
    orderBloc.getorderbyid(widget.transid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black87),
          textAlign: TextAlign.left,
        ),
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              left: MediaQuery.of(context).size.width * .4,
              child: Container(
                  child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .5,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFe12363), Color(0xFF82022d)])),
                  ),
                ),
              ))),
          StreamBuilder(
              stream: orderBloc.isInvoice,
              builder: (context, AsyncSnapshot<List<OrderViewModel>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return ShimmerInvoice(
                      text: 'Loading ....',
                    );
                  default:
                    if (snapshot.hasError) {
                      return ShimmerInvoice(text: 'Error');
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Center(
                            child: TicketPass(
                                alignment: Alignment.center,
                                animationDuration: Duration(milliseconds: 2),
                                expansionChild: Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Container(
                                        child: ListView(
                                      physics: BouncingScrollPhysics(),
                                      children: [
                                        new Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 120,
                                              child: new Text(
                                                'No. Invoice',
                                                style: new TextStyle(
                                                    fontSize: 12.0),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            new Text(
                                              ': ${snapshot.data[0].transid}',
                                              style:
                                                  new TextStyle(fontSize: 12.0),
                                            ),
                                          ],
                                        ),
                                        new Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 120,
                                              child: new Text(
                                                'Tanggal Transaksi',
                                                style: new TextStyle(
                                                    fontSize: 12.0),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            new Text(
                                              ': ${tanggal(DateTime.parse(snapshot.data[0].datetrans))}',
                                              style:
                                                  new TextStyle(fontSize: 12.0),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Container(
                                            child: new AnimatedList(
                                                initialItemCount: snapshot
                                                    .data[0].items.length,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index,
                                                    animation) {
                                                  return FadeTransition(
                                                      opacity: animation,
                                                      child: new SizeTransition(
                                                          sizeFactor: animation,
                                                          child: new Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          5.0),
                                                              child: new Row(
                                                                children: [
                                                                  new Padding(
                                                                    padding: new EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0 -
                                                                                12.0 / 2),
                                                                    child:
                                                                        new Container(
                                                                      height:
                                                                          12.0,
                                                                      width:
                                                                          12.0,
                                                                      decoration:
                                                                          new BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  new Expanded(
                                                                    child:
                                                                        new Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        new Text(
                                                                          snapshot
                                                                              .data[0]
                                                                              .items[index]
                                                                              .item,
                                                                          style:
                                                                              new TextStyle(fontSize: 14.0),
                                                                        ),
                                                                        new Text(
                                                                          (snapshot.data[0].items[index].disc == null)
                                                                              ? '${snapshot.data[0].items[index].qty} x ${formatter.format(snapshot.data[0].items[index].price)}'
                                                                              : '${snapshot.data[0].items[index].qty} x ${formatter.format(snapshot.data[0].items[index].price)} ' + '(Disc ${snapshot.data[0].items[index].disc} %)',
                                                                          style: new TextStyle(
                                                                              fontSize: 12.0,
                                                                              color: Colors.grey),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  new Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            16.0),
                                                                    child:
                                                                        new Text(
                                                                      'Rp. ${Formatter.number(double.parse(snapshot.data[0].items[index].subtotal.toString()))}',
                                                                      style: new TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ))));
                                                }))
                                      ],
                                    )),
                                  ),
                                ),
                                expandedHeight:
                                    MediaQuery.of(context).size.height / 1.4,
                                expandIcon: CircleAvatar(
                                  backgroundColor: jagodarkRed,
                                  maxRadius: 14,
                                  child: Icon(
                                    Themify.angle_double_down,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                expansionTitle: Text(
                                  'Detail Pesanan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                separatorColor: Colors.black,
                                separatorHeight: 0.5,
                                color: Colors.white.withOpacity(.8),
                                curve: Curves.easeOut,
                                titleColor: jagoRed,
                                shrinkIcon: Align(
                                  alignment: Alignment.centerRight,
                                  child: CircleAvatar(
                                    backgroundColor: jagodarkRed,
                                    maxRadius: 14,
                                    child: Icon(
                                      Themify.angle_double_up,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                ticketTitle: Text(
                                  'Detail Pasan',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                titleHeight: 50,
                                width: MediaQuery.of(context).size.width / 1.05,
                                height: MediaQuery.of(context).size.height / 2,
                                shadowColor: Colors.blue.withOpacity(0.5),
                                elevation: 8,
                                shouldExpand: true,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 15),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: 150.0,
                                              height: 25.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: Colors.green),
                                              ),
                                              child: Center(
                                                child: AutoSizeText(
                                                  '${Formatter.status(snapshot.data[0].status)}',
                                                  maxLines: 1,
                                                  maxFontSize: 12,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Image.asset(
                                                      'images/logo.png',
                                                      width: 24,
                                                    )),
                                                Text(
                                                  'SI JAGO',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 10.0,
                                                right: 10.0),
                                            child: Column(
                                              children: [
                                                BarCodeImage(
                                                  params: Code39BarCodeParams(
                                                    "${snapshot.data[0].transid}",
                                                    lineWidth: 1.0,
                                                    barHeight: 70.0,
                                                    withText: true,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5.0),
                                                      height: 20.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            width: .5,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      child: Center(
                                                        child: AutoSizeText(
                                                          '${Formatter.payment(snapshot.data[0].paystatus)}',
                                                          maxLines: 1,
                                                          maxFontSize: 12,
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        ),
                                                      ),
                                                    ),
                                                    AutoSizeText(
                                                      '${tanggal(DateTime.parse(snapshot.data[0].datetrans))}',
                                                      maxLines: 1,
                                                      maxFontSize: 12,
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Table(
                                                    defaultVerticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .top,
                                                    children: [
                                                      TableRow(children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5.0),
                                                          child: AutoSizeText(
                                                            'Total Barang',
                                                            maxLines: 1,
                                                            maxFontSize: 14,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87),
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5.0),
                                                            child: AutoSizeText(
                                                              '${snapshot.data[0].qty}',
                                                              maxLines: 1,
                                                              maxFontSize: 14,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87),
                                                            ))
                                                      ]),
                                                      TableRow(children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5.0),
                                                          child: AutoSizeText(
                                                            'Total Harga',
                                                            maxLines: 1,
                                                            maxFontSize: 14,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87),
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5.0),
                                                            child: AutoSizeText(
                                                              'Rp. ${formatter.format(snapshot.data[0].totalprice)}',
                                                              maxLines: 1,
                                                              maxFontSize: 14,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87),
                                                            ))
                                                      ]),
                                                      TableRow(
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                                      width: .6,
                                                                      color: Colors
                                                                          .black))),
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5.0),
                                                              child:
                                                                  AutoSizeText(
                                                                'Ongkos Kirim',
                                                                maxLines: 1,
                                                                maxFontSize: 14,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black87),
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5.0),
                                                                child:
                                                                    AutoSizeText(
                                                                  'Rp. ${formatter.format(snapshot.data[0].ongkir)}',
                                                                  maxLines: 1,
                                                                  maxFontSize:
                                                                      14,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black87),
                                                                ))
                                                          ]),
                                                      TableRow(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .withOpacity(
                                                                          .3)),
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5.0,
                                                                  horizontal:
                                                                      5.0),
                                                              child:
                                                                  AutoSizeText(
                                                                'Total Pembayaran',
                                                                maxLines: 1,
                                                                maxFontSize: 16,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        5.0,
                                                                    horizontal:
                                                                        5.0),
                                                                child: AutoSizeText(
                                                                    'Rp. ${formatter.format(snapshot.data[0].totalprice + snapshot.data[0].ongkir)}',
                                                                    maxLines: 1,
                                                                    maxFontSize:
                                                                        16,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight.bold)))
                                                          ]),
                                                      TableRow(children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5.0),
                                                          child: AutoSizeText(
                                                            'Metode Pembayaran',
                                                            maxLines: 1,
                                                            maxFontSize: 12,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              AutoSizeText(
                                                                '${snapshot.data[0].payment}',
                                                                maxLines: 2,
                                                                maxFontSize: 12,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black87),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ]),
                                                      (snapshot.data[0]
                                                                  .paystatus ==
                                                              1)
                                                          ? TableRow(children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5.0),
                                                                child:
                                                                    AutoSizeText(
                                                                  'Yang harus di bayar',
                                                                  maxLines: 1,
                                                                  maxFontSize:
                                                                      14,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black87),
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          5.0),
                                                                  child:
                                                                      AutoSizeText(
                                                                    'Rp. ${formatter.format((snapshot.data[0].totalprice + snapshot.data[0].ongkir) - snapshot.data[0].paysaldo)}',
                                                                    maxLines: 1,
                                                                    maxFontSize:
                                                                        14,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ))
                                                            ])
                                                          : TableRow(children: [
                                                              Container(),
                                                              Container()
                                                            ])
                                                    ])
                                              ],
                                            ))
                                      ],
                                    ))),
                          ),
                        ),
                      ],
                    );
                }
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TrackingPage(
                          title: 'Tracking Pesanan Anda',
                          transid: widget.transid,
                        )));
          },
          child: Icon(
            Icons.near_me,
            size: 36,
          ),
          backgroundColor: jagoRed),
    );
  }
}
