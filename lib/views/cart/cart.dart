import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/custom_divider_view.dart';
import 'package:jagomart/helpers/dotted_seperator_view.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/cart/cart_model.dart';
import 'package:jagomart/viewmodels/cart/cart_view_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/cart/payment.dart';
import 'package:jagomart/views/signout.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:transparent_image/transparent_image.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  ScrollController _scrollViewController = new ScrollController();

  @override
  void initState() {
    Provider.of<CartListViewModel>(context, listen: false).getcart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var va = Provider.of<AuthListViewModel>(context);
    return _pages(va);
  }

  Widget _pages(AuthListViewModel vs) {
    var vc = Provider.of<CartListViewModel>(context);
    switch (vs.loadingStatus) {
      case LoadingStatusAuth.signout:
        return SignOutPage();
      case LoadingStatusAuth.signin:
        return _cart(vc);

      default:
        return SignOutPage();
    }
  }

  Widget _cart(CartListViewModel vc) {
    switch (vc.loadingStatus) {
      case LoadingStatusCart.searching:
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Belanjaan Anda',
              style: GoogleFonts.lato(),
            ),
          ),
          body: Center(
            child: Container(
              height: 45,
              child: LoadingIndicator(
                indicatorType: Indicator.circleStrokeSpin,
                color: jagoRed,
              ),
            ),
          ),
        );
        break;

      case LoadingStatusCart.completed:
        return Consumer<CartListViewModel>(
          builder: (context, vc, _) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Belanjaan Anda',
                  style: GoogleFonts.lato(),
                ),
              ),
              body: SafeArea(
                  child: SingleChildScrollView(
                      controller: _scrollViewController,
                      physics: BouncingScrollPhysics(),
                      child: Container(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: vc.cart.length,
                            itemBuilder: (context, i) {
                              return _OrderView(
                                list: vc.cart[i],
                                index: i,
                                cartModel: vc,
                              );
                            },
                          ),
                          CustomDividerView(
                            dividerHeight: 10.0,
                            color: Colors.grey[400],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.library_books,
                                    color: Colors.grey[700]),
                                Text('Berikut adalah total belanjaan anda.')
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    AutoSizeText('Total Items',
                                        minFontSize: 8,
                                        maxFontSize: 12,
                                        style: GoogleFonts.lato()),
                                    AutoSizeText(
                                        '${formatter.format(vc.totalItems)}',
                                        minFontSize: 8,
                                        maxFontSize: 12,
                                        style: GoogleFonts.lato()),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    AutoSizeText('Total Qty',
                                        minFontSize: 8,
                                        maxFontSize: 12,
                                        style: GoogleFonts.lato()),
                                    AutoSizeText(
                                        '${formatter.format(vc.totalqty)}',
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
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              AutoSizeText('Total Belanja',
                                                  minFontSize: 12,
                                                  maxFontSize: 14,
                                                  style: GoogleFonts.lato()),
                                              AutoSizeText(
                                                  'Rp. ${formatter.format(vc.totalPrice)}',
                                                  minFontSize: 12,
                                                  maxFontSize: 16,
                                                  style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                            ],
                                          ),
                                          Divider(),
                                          Text(
                                            'Total belanjaan belum termasuk ongkos kirim, apabila sudah sesuai silahkan lanjutkan ke proses pembayaran',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(fontSize: 13.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  height: 45.0,
                                  width: double.infinity,
                                  child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                      side: BorderSide(color: Colors.red),
                                    ),
                                    child: Text(
                                      "Buat Pesanan",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    color: jagoRed,
                                    onPressed: () {
                                      pushReplacement(context, PaymentPage());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )))),
            );
          },
        );
        break;

      case LoadingStatusCart.empty:
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Belanjaan Anda',
              style: GoogleFonts.lato(),
            ),
          ),
          body: Center(
              child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: FlareActor(
                    "assets/Empty.flr",
                    animation: "empty",
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.center,
                  ),
                ),
                AutoSizeText(
                  'Belanjaan Anda Kosong',
                  style: GoogleFonts.lato(fontSize: 18.0),
                ),
              ],
            ),
          )),
        );
    }
  }
}

class _OrderView extends StatefulWidget {
  final CartViewModel list;
  final index;
  final CartListViewModel cartModel;
  _OrderView({this.list, this.index, this.cartModel});
  @override
  __OrderViewState createState() => __OrderViewState();
}

class __OrderViewState extends State<_OrderView> {
  Future<void> deletedKeranjang() async {
    widget.cartModel.deletedKeranjang(widget.index, widget.list.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 2.8,
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: widget.list.image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: AutoSizeText('${widget.list.item}',
                          maxFontSize: 16,
                          minFontSize: 8,
                          maxLines: 2,
                          style: GoogleFonts.lato())),
                  (widget.list.disc == null || widget.list.disc == 0)
                      ? AutoSizeText(
                          'Rp. ${formatter.format(widget.list.price)}',
                          maxFontSize: 16,
                          minFontSize: 8,
                          style: GoogleFonts.lato())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: AutoSizeText(
                                  'Rp. ${formatter.format(widget.list.pricedisc)}',
                                  maxFontSize: 16,
                                  minFontSize: 8,
                                  style: GoogleFonts.lato()),
                            ),
                            AutoSizeText(
                              'Rp. ${formatter.format(widget.list.price)}',
                              maxFontSize: 16,
                              minFontSize: 8,
                              textAlign: TextAlign.end,
                              style: GoogleFonts.lato(
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 2,
                                  decorationColor: Colors.black38,
                                  decorationStyle: TextDecorationStyle.double),
                            ),
                          ],
                        ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: DottedSeperatorView(),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          height: 25.0,
                          width: 90.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                child: Icon(Icons.remove, color: jagoRed),
                                onTap: () async {
                                  if (widget.list.qty > 1) {
                                    widget.cartModel.updateKeranjang(
                                        widget.list.id, widget.list.qty - 1);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Minimal 1 Item",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: jagoRed,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                },
                              ),
                              Spacer(),
                              AutoSizeText('${widget.list.qty}',
                                  maxFontSize: 12,
                                  minFontSize: 8,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(fontSize: 16.0)),
                              Spacer(),
                              InkWell(
                                child: Icon(Icons.add, color: Colors.green),
                                onTap: () {
                                  widget.cartModel.updateKeranjang(
                                      widget.list.id, widget.list.qty + 1);
                                },
                              )
                            ],
                          ),
                        ),
                        AutoSizeText(
                          ' = Rp. ${formatter.format(widget.list.pricedisc * widget.list.qty)}',
                          maxFontSize: 14,
                          minFontSize: 12,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        IconButton(
                          icon: Icon(
                            Themify.trash,
                            color: jagoRed,
                          ),
                          onPressed: () {
                            SweetAlert.show(context,
                                title: "Hapus Keranjang",
                                subtitle: "Apakah yakin kak?.",
                                style: SweetAlertStyle.confirm,
                                cancelButtonText: 'Tidak',
                                confirmButtonText: 'Ya',
                                confirmButtonColor: jagoRed,
                                showCancelButton: true,
                                onPress: (bool isConfirm) {
                              if (isConfirm) {
                                SweetAlert.show(context,
                                    subtitle: "Hapus Keranjang...",
                                    style: SweetAlertStyle.loading);
                                new Future.delayed(
                                    new Duration(milliseconds: 200), () async {
                                  deletedKeranjang();
                                });
                              } else {
                                Navigator.of(context).pop();
                              }
                              return false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
