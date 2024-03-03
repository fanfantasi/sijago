import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/alamat/alamat.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themify_flutter/themify_flutter.dart';

class AlamatWidget extends StatefulWidget {
  @override
  _AlamatWidgetState createState() => _AlamatWidgetState();
}

class _AlamatWidgetState extends State<AlamatWidget> {
  @override
  void initState() {
    Provider.of<CartListViewModel>(context, listen: false).getalamat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var va = Provider.of<CartListViewModel>(context);
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
                    AutoSizeText('Alamat Pengiriman',
                        maxFontSize: 16,
                        minFontSize: 12,
                        style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
                  ],
                )),
            subtitle: Container(width: double.infinity, child: _alamat(va)),
            trailing: Icon(Themify.arrow_circle_right),
          ),
        ));
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlamatPage()),
    );
    if (result == 1) {
      Provider.of<CartListViewModel>(context, listen: false).getalamat();
    }
  }

  Widget _alamat(CartListViewModel va) {
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Themify.location_pin),
                SizedBox(width: 10),
                Expanded(
                  child: AutoSizeText(
                    '${va.alamatSelected}',
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            Divider(),
            Container(
              width: MediaQuery.of(context).size.width / 1,
              child: AutoSizeText(
                'Waktu Perkiraan : ${va.waktu.toStringAsFixed(0)} Menit, Jarak ${double.parse(va.distance).toStringAsFixed(2)} KM',
                maxFontSize: 12,
                minFontSize: 10,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
        break;

      case LoadingStatusCart.empty:
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Themify.location_pin),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: AutoSizeText('${va.alamatSelected}'),
                ),
              ],
            ),
            Divider(),
            Container(
              width: MediaQuery.of(context).size.width / 4,
              child: AutoSizeText(
                '0 Menit',
                maxFontSize: 12,
                minFontSize: 10,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
    }
  }
}
