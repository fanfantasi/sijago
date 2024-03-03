import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/viewmodels/saldo/saldo_view_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themify_flutter/themify_flutter.dart';

class SaldoWidget extends StatefulWidget {
  final SaldoListViewModel vs;
  SaldoWidget({Key key, this.vs}) : super(key: key);
  @override
  _SaldoWidgetState createState() => _SaldoWidgetState();
}

class _SaldoWidgetState extends State<SaldoWidget> {
  //Loding Saldo
  Widget _saldo(SaldoListViewModel vs) {
    switch (vs.loadingStatus) {
      case LoadingStatusSaldo.searching:
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Color(0xFFe60f4c),
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
            style: GoogleFonts.lato(color: Colors.white));
      case LoadingStatusSaldo.empty:
      default:
        return AutoSizeText('Rp. ${formatter.format(0)}',
            maxFontSize: 14,
            minFontSize: 10,
            style: GoogleFonts.lato(color: Colors.white));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
          color: jagoRed,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Themify.wallet,
                  color: jagoWhite,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: AutoSizeText(
                      'Saldo',
                      style: GoogleFonts.lato(color: jagoWhite),
                    ))
              ],
            ),
            _saldo(widget.vs)
          ],
        ),
      ),
    );
  }
}
