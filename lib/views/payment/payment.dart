import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/viewmodels/payment/payment_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:themify_flutter/themify_flutter.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  ScrollController _scrollViewController = new ScrollController();
  final paymentBloc = PaymentBloc();

  @override
  void initState() {
    super.initState();
    paymentBloc.getpayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Metode Pembayaran',
          style: GoogleFonts.lato(),
        ),
      ),
      body: StreamBuilder(
        stream: paymentBloc.paymentStream,
        builder: (context, AsyncSnapshot<List<PaymentViewModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Container(
                  color: Colors.transparent,
                  width: 65,
                  height: 65,
                  padding: EdgeInsets.all(12.0),
                  child: LoadingIndicator(
                      color: jagoRed,
                      indicatorType: Indicator.circleStrokeSpin),
                ),
              );
              break;

            default:
              if (snapshot.hasError) {
                return Container();
              }

              return ListView.separated(
                controller: _scrollViewController,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString(
                          'payment', snapshot.data[i].payment);
                      await prefs.setString(
                          'payid', snapshot.data[i].id.toString());
                      await prefs.setString(
                          'iconpayment', snapshot.data[i].icon);
                      await prefs.setInt(
                          'statusPayment', snapshot.data[i].status);
                      await prefs.setString(
                          'rekening', snapshot.data[i].rekening);
                      Navigator.of(context).pop(1);
                    },
                    child: ListTile(
                      leading: Icon(Themify.wallet),
                      title: Text(
                        '${snapshot.data[i].payment}',
                        style: TextStyle(color: Colors.black87, fontSize: 16.0),
                      ),
                      trailing: Image.network(
                        snapshot.data[i].icon,
                        width: 52.0,
                        height: 42.0,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return Divider();
                },
              );
          }
        },
      ),
    );
  }
}
