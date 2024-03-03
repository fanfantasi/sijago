import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/payment/payment.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:themify_flutter/themify_flutter.dart';

class PaymentWidget extends StatefulWidget {
  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  @override
  void initState() {
    Provider.of<CartListViewModel>(context, listen: false).getPayment();
    Provider.of<SaldoListViewModel>(context, listen: false).getsaldo();
    clearpayment();
    super.initState();
  }

  Future<void> clearpayment() async {
    var vc = Provider.of<CartListViewModel>(context, listen: false);
    vc.getchecklist(false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.remove('payment');
      prefs.remove('payid');
      prefs.remove('iconpayment');
      prefs.remove('statusPayment');
      prefs.remove('rekening');
    });
    vc.getPayment();
  }

  @override
  Widget build(BuildContext context) {
    var va = Provider.of<CartListViewModel>(context);
    var vs = Provider.of<SaldoListViewModel>(context);
    return InkWell(
        onTap: () {
          _navigateAndDisplaySelection(context);
        },
        child: Container(
          margin: const EdgeInsets.only(top: 5.0),
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          color: Colors.white,
          child: ListTile(
            title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 3,
                      height: 20,
                      color: Colors.black87,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    AutoSizeText('Metode Pembayaran',
                        maxFontSize: 16,
                        minFontSize: 12,
                        style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
                  ],
                )),
            subtitle: Column(children: [
              Container(child: _payment(va)),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "SALDO ANDA",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  _saldo(vs)
                ],
              ),
            ]),
            trailing: Icon(Themify.arrow_circle_right),
          ),
        ));
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage()),
    );
    if (result == 1) {
      Provider.of<CartListViewModel>(context, listen: false).getPayment();
      var vc = Provider.of<CartListViewModel>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if ((prefs.getInt('statusPayment') == 1) &&
          (vc.saldo[0].saldo -
                  (vc.totalPrice + int.parse(vc.ongkos.toStringAsFixed(0))) <
              0)) {
        setState(() {
          prefs.remove('payment');
          prefs.remove('payid');
          prefs.remove('iconpayment');
          prefs.remove('statusPayment');
          prefs.remove('rekening');
        });
        await vc.getPayment();
        await vc.getchecklist(false);
        SweetAlert.show(
          context,
          title: "Saldo Anda tidak cukup",
          subtitle: "Silahkan pilih Metode pembayaran yang lain.",
          confirmButtonColor: jagoRed,
        );
      } else if (prefs.getInt('statusPayment') != 1) {
        await vc.getchecklist(false);
      } else {
        await vc.getchecklist(true);
      }
    }
  }

  //Saldo
  Widget _saldo(SaldoListViewModel vs) {
    switch (vs.loadingStatus) {
      case LoadingStatusSaldo.searching:
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.green,
          child: Container(
            child: AutoSizeText(
              'Cek Saldo',
              maxFontSize: 14,
              minFontSize: 10,
            ),
          ),
        );
      case LoadingStatusSaldo.completed:
        return AutoSizeText('Rp. ${formatter.format(vs.saldo[0].saldo)}',
            maxFontSize: 14,
            minFontSize: 10,
            style: GoogleFonts.lato(color: Colors.green));
      case LoadingStatusSaldo.empty:
      default:
        return AutoSizeText('Rp. ${formatter.format(0)}',
            maxFontSize: 14,
            minFontSize: 10,
            style: GoogleFonts.lato(color: Colors.green));
    }
  }

  //Payment
  Widget _payment(CartListViewModel va) {
    switch (va.loadingStatus) {
      case LoadingStatusCart.searching:
        return Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.white,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: 10.0,
                  color: Colors.white,
                ),
              ],
            ));
        break;

      case LoadingStatusCart.completed:
        return Row(
          children: [
            (va.iconpaymentSelected == null)
                ? Icon(Themify.wallet)
                : Image.network(va.iconpaymentSelected, width: 45),
            SizedBox(
              width: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: AutoSizeText('${va.paymentSelected}'),
            ),
          ],
        );
        break;

      case LoadingStatusCart.empty:
      default:
        return Row(
          children: [
            Icon(Themify.wallet),
            SizedBox(
              width: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: AutoSizeText('${va.paymentSelected}'),
            ),
          ],
        );
    }
  }
}
