import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/helpers/toast.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/auth/login_model.dart';
import 'package:jagomart/views/auth/loginpage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'verifikasiotp.dart';

class OtpLoginPage extends StatefulWidget {
  final phone;
  OtpLoginPage({Key key, @required this.phone}) : super(key: key);
  @override
  _OtpLoginPageState createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> {
  bool isLoading = false;
  List<LoginViewModel> login = [];

  void sendOTPWA() async {
    List<LoginModel> _phone = await Webservice().sendOtp(widget.phone);
    this.login = _phone.map((e) => LoginViewModel(login: e)).toList();
    Timer(Duration(microseconds: 200), () async {
      if (this.login[0].status) {
        showMessage(context, this.login[0].message);
        setState(() {
          isLoading = false;
        });
        pushReplacement(
            context,
            Verifikasiotp(
              title: 'Kode Rahasia',
              phone: widget.phone,
            ));
      } else {
        showMessage(context, this.login[0].message);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Verifikasi',
            style: TextStyle(color: Colors.black87),
          ),
          leading: InkWell(
            onTap: () => pushReplacement(context, LoginPage()),
            child: Icon(
              CupertinoIcons.left_chevron,
              color: Colors.black87,
              size: 32.0,
            ),
          )),
      body: ModalProgressHUD(
          inAsyncCall: isLoading ? true : false,
          progressIndicator: Center(
            child: Container(
              color: Colors.transparent,
              width: 65,
              height: 65,
              padding: EdgeInsets.all(12.0),
              child: LoadingIndicator(
                  indicatorType: Indicator.circleStrokeSpin, color: jagoRed),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 10.0, left: 8.0, right: 8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Kirim Kode Rahasia',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    AutoSizeText(
                      'Kode Rahasia akan dikirim ke nomor Whatsapp anda',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isLoading = true;
                    });
                    sendOTPWA();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: ListTile(
                        leading: Image.asset(
                          'images/whatsapp.png',
                          width: 32.0,
                        ),
                        title: AutoSizeText(
                          'Melalui Whatsapp ke Nomor ${widget.phone}',
                          maxFontSize: 14,
                          maxLines: 1,
                        )),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
