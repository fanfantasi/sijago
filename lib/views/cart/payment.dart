import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/custom_divider_view.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/pesanan/pesanan.dart';
import 'package:jagomart/views/widget/card_alamat.dart';
import 'package:jagomart/views/widget/card_payment.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:themify_flutter/themify_flutter.dart';

double totalprice;

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  ScrollController _scrollViewController = new ScrollController();
  final remarks = TextEditingController();
  final orderBloc = OrderBloc();

  @override
  void initState() {
    Provider.of<CartListViewModel>(context, listen: false).getcart();
    Provider.of<CartListViewModel>(context, listen: false).getsaldo();
    Provider.of<CartListViewModel>(context, listen: false).getongkir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vc = Provider.of<CartListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Proses Pembayaran',
          style: GoogleFonts.lato(),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollViewController,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            AlamatWidget(),
            PaymentWidget(),
            CustomDividerView(
              dividerHeight: 5.0,
              color: Colors.grey[400],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              color: Colors.white,
              child: ListTile(
                title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AutoSizeText(
                          'Informasi',
                          maxFontSize: 14,
                          minFontSize: 12,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(fontSize: 14.0),
                        ),
                        Icon(Icons.info_outline, size: 14.0)
                      ],
                    )),
                subtitle: AutoSizeText(
                  'Barang dengan status Pre Order akan dilakukan pengiriman di Esok Hari atau pada hari berikutnya pada jam 08.00 - 14.00.',
                  maxLines: 3,
                  minFontSize: 12.0,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(),
                ),
                isThreeLine: true,
              ),
            ),
            CustomDividerView(
              dividerHeight: 5.0,
              color: Colors.grey[400],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              color: Colors.white,
              child: ListTile(
                title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AutoSizeText(
                          'Catatan untuk penjual',
                          maxFontSize: 14,
                          minFontSize: 12,
                          style: GoogleFonts.lato(),
                        ),
                        Icon(
                          Icons.info_outline,
                          size: 14.0,
                          color: jagoRed,
                        )
                      ],
                    )),
                subtitle: TextField(
                    controller: remarks,
                    maxLines: 2,
                    maxLength: 200,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(.5),
                          width: .8,
                        ),
                      ),
                    )),
                isThreeLine: true,
              ),
            ),
            CustomDividerView(
              dividerHeight: 10.0,
              color: Colors.grey[400],
            ),
            Container(
              height: 50.0,
              color: Colors.black,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Themify.email, color: Colors.green),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      final string = Config.phonecabang;
                      final replase = string.replaceFirst(RegExp('0'), '+62');
                      FlutterOpenWhatsapp.sendSingleMessage(
                          "$replase", "Hallo Kak.");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: AutoSizeText(
                        'Ada yang ditanyakan, silahkan hubungi kami disini.',
                        maxFontSize: 14,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Nota Pesanan Anda',
                    maxFontSize: 16,
                    minFontSize: 12,
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  Divider(),
                  _NotaTotalHarga(
                    vc: vc,
                  ),
                  _NotaOngkosKirim(
                    vo: vc,
                  ),
                  Divider(),
                  _NotaTotal(
                    vc: vc,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    height: 45.0,
                    width: double.infinity,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.green),
                      ),
                      child: Text(
                        "Lanjutkan",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: jagoRed,
                      onPressed: () {
                        _confirm(vc, remarks);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _confirm(CartListViewModel vc, catatan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('deliverid');
    if (prefs.getString('payid') == null || prefs.getString('payid') == '0') {
      SweetAlert.show(
        context,
        title: "Pembayaran",
        subtitle: "Metode Pembayaran belum ditentukan.",
        confirmButtonColor: jagoRed,
      );
    } else if (prefs.getString('deliverid') == '0' ||
        prefs.getString('deliverid') == null ||
        vc.alamatSelected == '') {
      SweetAlert.show(
        context,
        title: "Alamat",
        subtitle: "Alamat pengiriman belum ditentukan.",
        confirmButtonColor: jagoRed,
      );
    } else {
      SweetAlert.show(context,
          subtitle: "Apakah sudah yakin ?...",
          style: SweetAlertStyle.confirm,
          cancelButtonText: 'Tidak',
          confirmButtonText: 'Ya',
          confirmButtonColor: jagoRed,
          showCancelButton: true, onPress: (bool isConfirm) {
        if (isConfirm) {
          SweetAlert.show(context,
              subtitle: "Mengirim Transaksi", style: SweetAlertStyle.loading);
          new Future.delayed(new Duration(milliseconds: 100), () async {
            final aksi = await vc.insertTransaksi(
                remarks.text, vc.ongkos, vc.saldo[0].saldo, vc.saldocust);
            if (aksi.status == true) {
              Fluttertoast.showToast(
                  msg: aksi.message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.7),
                  textColor: Colors.white,
                  fontSize: 14.0);
              Navigator.of(context).pop();
              pushReplacement(
                  context,
                  PesananPage(
                    title: 'Invoice Transaksi',
                    transid: aksi.transid,
                  ));
              await vc.getcart();
              await orderBloc.getHistorytop(1);
            } else {
              Fluttertoast.showToast(
                  msg: aksi.message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.7),
                  textColor: Colors.white,
                  fontSize: 14.0);
              Navigator.of(context).pop();
            }
          });
        } else {
          Navigator.of(context).pop();
        }
        return false;
      });
    }
  }
}

class _NotaTotalHarga extends StatelessWidget {
  final CartListViewModel vc;
  _NotaTotalHarga({this.vc});
  @override
  Widget build(BuildContext context) {
    switch (vc.loadingStatus) {
      case LoadingStatusCart.searching:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText('Total Harga',
                minFontSize: 12, maxFontSize: 16, style: GoogleFonts.lato()),
            Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Color(0xFFe60f4c),
              child: Container(
                child: AutoSizeText(
                  'Cek Total Harga',
                  maxFontSize: 14,
                  minFontSize: 10,
                ),
              ),
            )
          ],
        );
        break;

      case LoadingStatusCart.completed:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText('Total Harga',
                minFontSize: 12, maxFontSize: 16, style: GoogleFonts.lato()),
            AutoSizeText('Rp. ${formatter.format(vc.totalPrice)}',
                minFontSize: 12,
                maxFontSize: 16,
                style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
          ],
        );
        break;

      case LoadingStatusCart.empty:
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText('Total Harga',
                minFontSize: 12, maxFontSize: 16, style: GoogleFonts.lato()),
            AutoSizeText('Rp. 0',
                minFontSize: 12,
                maxFontSize: 16,
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold, color: Colors.red)),
          ],
        );
    }
  }
}

class _NotaOngkosKirim extends StatelessWidget {
  final CartListViewModel vo;
  _NotaOngkosKirim({this.vo});

  @override
  Widget build(BuildContext context) {
    switch (vo.loadingStatus) {
      case LoadingStatusCart.searching:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText('Ongkos Kirim',
                minFontSize: 12, maxFontSize: 16, style: GoogleFonts.lato()),
            Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Color(0xFFe60f4c),
              child: Container(
                child: AutoSizeText(
                  'Cek Ongkos Kirim',
                  maxFontSize: 14,
                  minFontSize: 10,
                ),
              ),
            )
          ],
        );
        break;

      case LoadingStatusCart.completed:
        totalprice = vo.ongkos.toDouble();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText('Ongkos Kirim',
                minFontSize: 12, maxFontSize: 16, style: GoogleFonts.lato()),
            AutoSizeText('Rp. ${formatter.format(vo.ongkos)}',
                minFontSize: 12,
                maxFontSize: 16,
                style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
          ],
        );
        break;

      case LoadingStatusCart.empty:
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText('Ongkos Kirim',
                minFontSize: 12, maxFontSize: 16, style: GoogleFonts.lato()),
            AutoSizeText('Rp. ${formatter.format(0)}',
                minFontSize: 12,
                maxFontSize: 16,
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold, color: Colors.red)),
          ],
        );
    }
  }
}

class _NotaTotal extends StatefulWidget {
  final CartListViewModel vc;
  _NotaTotal({this.vc});

  @override
  __NotaTotalState createState() => __NotaTotalState();
}

class __NotaTotalState extends State<_NotaTotal> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    var loadtotal = widget.vc.loadingStatus;
    if (loadtotal == LoadingStatusCart.searching) {
      return Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText('Gunakan Saldo',
                  minFontSize: 12, maxFontSize: 16, style: GoogleFonts.lato()),
              Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width / 2,
                  color: Colors.white,
                ),
              )
            ],
          ),
          SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText('Total Pembayaran',
                  minFontSize: 12, maxFontSize: 16, style: GoogleFonts.lato()),
              Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Color(0xFFe60f4c),
                child: Container(
                  child: AutoSizeText(
                    'Cek Total Pembayaran',
                    maxFontSize: 14,
                    minFontSize: 10,
                  ),
                ),
              )
            ],
          )
        ],
      );
    } else if (loadtotal == LoadingStatusCart.completed) {
      isLoading = false;
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText('Gunakan Saldo',
                  minFontSize: 12, maxFontSize: 16, style: GoogleFonts.lato()),
              (isLoading)
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Color(0xFFe60f4c),
                      child: Container(
                        child: AutoSizeText(
                          'Cek Total Pembayaran',
                          maxFontSize: 14,
                          minFontSize: 10,
                        ),
                      ),
                    )
                  : Checkbox(
                      value: widget.vc.checksaldo,
                      activeColor: Colors.green,
                      onChanged: (bool value) async {
                        setState(() {
                          isLoading = true;
                        });
                        await widget.vc.getchecklist(value);
                      },
                    ),
              Spacer(),
              AutoSizeText('Rp. ${formatter.format(widget.vc.saldocust)}',
                  minFontSize: 12, maxFontSize: 16, style: GoogleFonts.lato())
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText('Total Pembayaran',
                  minFontSize: 12, maxFontSize: 16, style: GoogleFonts.lato()),
              AutoSizeText(
                  'Rp. ${formatter.format((widget.vc.totalPrice + int.parse(widget.vc.ongkos.toStringAsFixed(0))) - widget.vc.saldocust)}',
                  minFontSize: 12,
                  maxFontSize: 16,
                  style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
            ],
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText('Total Pembayaran',
              minFontSize: 12, maxFontSize: 16, style: GoogleFonts.lato()),
          AutoSizeText('Rp. ${formatter.format(0)}',
              minFontSize: 12,
              maxFontSize: 16,
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold, color: Colors.red)),
        ],
      );
    }
  }
}
