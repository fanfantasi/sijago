import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/date_util.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/viewmodels/order/order_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:themify_flutter/themify_flutter.dart';

class ReviewPage extends StatefulWidget {
  final OrderViewModel vo;
  ReviewPage({@required this.vo});
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double rating;
  TextEditingController _textEditingController;
  int currentPage = 1;
  bool isShowSticker;
  final orderBloc = OrderBloc();

  @override
  void initState() {
    super.initState();
    isShowSticker = false;
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key('kategoriwidget'),
        direction: DismissDirection.vertical,
        onDismissed: (direction) {
          Navigator.pop(context, Duration(microseconds: 0));
        },
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: WillPopScope(
              onWillPop: onBackPress,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(top: kToolbarHeight * 5),
                  child: Stack(children: <Widget>[
                    Column(children: [
                      Align(
                          heightFactor: 4,
                          alignment: Alignment.center,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(height: 2),
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      width: 46,
                                      height: 3,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color: Colors.grey),
                                    )),
                                SizedBox(height: 2),
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      width: 36,
                                      height: 3,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color: Colors.grey),
                                    )),
                              ])),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 15.0),
                        height: 40.0,
                        color: Colors.grey[200],
                        child: Text('Review',
                            style: GoogleFonts.lato(fontSize: 16.0)),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: [
                                  AutoSizeText(
                                    'Berapa Ratingnya ?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Colors.black87),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: RatingBar.builder(
                                      initialRating: 4,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 2.0),
                                      itemSize: 48.0,
                                      itemBuilder: (context, _) => Icon(
                                        Themify.star,
                                        color: jagoRed,
                                      ),
                                      onRatingUpdate: (value) {
                                        rating = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.library_books,
                                          color: Colors.grey[700]),
                                      Text('Belanjaan anda.')
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Nota Belanjaan Anda',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(fontSize: 17.0),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          AutoSizeText('No. Invoice',
                                              minFontSize: 8,
                                              maxFontSize: 12,
                                              style: GoogleFonts.lato()),
                                          AutoSizeText('${widget.vo.transid}',
                                              minFontSize: 8,
                                              maxFontSize: 12,
                                              style: GoogleFonts.lato()),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          AutoSizeText('Tanggal',
                                              minFontSize: 8,
                                              maxFontSize: 12,
                                              style: GoogleFonts.lato()),
                                          AutoSizeText(
                                              '${tanggal(DateTime.parse(widget.vo.datetrans))}',
                                              minFontSize: 8,
                                              maxFontSize: 12,
                                              style: GoogleFonts.lato()),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          AutoSizeText('Total Items Belanja',
                                              minFontSize: 8,
                                              maxFontSize: 12,
                                              style: GoogleFonts.lato()),
                                          AutoSizeText(
                                              '${formatter.format(widget.vo.qty)}',
                                              minFontSize: 8,
                                              maxFontSize: 12,
                                              style: GoogleFonts.lato()),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    AutoSizeText(
                                                        'Total Belanja',
                                                        minFontSize: 12,
                                                        maxFontSize: 14,
                                                        style:
                                                            GoogleFonts.lato()),
                                                    AutoSizeText(
                                                        'Rp. ${formatter.format(widget.vo.totalprice)}',
                                                        minFontSize: 12,
                                                        maxFontSize: 16,
                                                        style: GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    AutoSizeText('Ongkos Kirim',
                                                        minFontSize: 12,
                                                        maxFontSize: 14,
                                                        style:
                                                            GoogleFonts.lato()),
                                                    AutoSizeText(
                                                        'Rp. ${formatter.format(widget.vo.ongkir)}',
                                                        minFontSize: 12,
                                                        maxFontSize: 16,
                                                        style: GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                                Divider(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    AutoSizeText('Grand Total ',
                                                        minFontSize: 12,
                                                        maxFontSize: 14,
                                                        style:
                                                            GoogleFonts.lato()),
                                                    AutoSizeText(
                                                        'Rp. ${formatter.format(widget.vo.totalprice + widget.vo.ongkir)}',
                                                        minFontSize: 12,
                                                        maxFontSize: 16,
                                                        style: GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                      // Input content
                      buildInput(),

                      // Sticker
                      (isShowSticker ? buildSticker() : Container()),
                    ]),
                  ])),
            )));
  }

  Widget buildSticker() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: ["racing", "horse", "face", "happy", "party", "sad"],
      numRecommended: 50,
      onEmojiSelected: (emoji, category) {
        _textEditingController.text = _textEditingController.text + emoji.emoji;
        _textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: _textEditingController.text.length));
      },
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Themify.face_smile, color: Colors.blueGrey),
                onPressed: () {
                  setState(() {
                    isShowSticker = !isShowSticker;
                  });
                },
                color: Colors.black87,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: GoogleFonts.lato(color: Colors.blueGrey, fontSize: 14.0),
                decoration: InputDecoration.collapsed(
                  hintText: 'Tulis komentar anda...',
                  hintStyle: TextStyle(color: Colors.blueGrey),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () async {
                  if (_textEditingController.text.isNotEmpty) {
                    await orderBloc.getorderbyid(widget.vo.transid);
                    SweetAlert.show(context,
                        subtitle: "Mengirim Review",
                        style: SweetAlertStyle.loading);
                    new Future.delayed(new Duration(seconds: 2), () async {
                      await orderBloc.insertReview(
                          widget.vo.transid,
                          (rating == null) ? 4 : rating,
                          _textEditingController.text,
                          json.encode(orderBloc.orderdetail[0].items));
                      setState(() {
                        _textEditingController.clear();
                      });
                      if (orderBloc.aksi[0].status == true) {
                        setState(() {
                          _textEditingController.clear();
                        });
                        SweetAlert.show(context,
                            subtitle: "Sukses!",
                            style: SweetAlertStyle.success,
                            confirmButtonColor: jagoRed,
                            onPress: (bool isConfirm) {
                          Navigator.pop(context, 1);
                          return;
                        });
                      } else {
                        SweetAlert.show(context,
                            subtitle: "Error!",
                            style: SweetAlertStyle.error,
                            confirmButtonColor: jagoRed,
                            onPress: (bool isConfirm) {
                          Navigator.pop(context);
                          return;
                        });
                      }
                    });
                    return false;
                  }
                },
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: Colors.blueGrey, width: 0.5)),
          color: Colors.white),
    );
  }
}
