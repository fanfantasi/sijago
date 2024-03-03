import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/helpers/toast.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/auth/login_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/auth/otplogin.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class Verifikasiotp extends StatefulWidget {
  final title;
  final phone;
  Verifikasiotp({Key key, @required this.title, @required this.phone})
      : super(key: key);
  @override
  _VerifikasiotpState createState() => _VerifikasiotpState();
}

class _VerifikasiotpState extends State<Verifikasiotp> {
  var onTapRecognizer;
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  List<LoginViewModel> login = [];

  bool isLoading = false;
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() async {
    errorController.close();
    super.dispose();
  }

  void checkotp(String pin) async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var playerId = status.subscriptionStatus.userId;
    List<LoginModel> _phone =
        await Webservice().getOtp(pin, widget.phone, playerId);
    this.login = _phone.map((e) => LoginViewModel(login: e)).toList();
    if (this.login[0].status) {
      Provider.of<AuthListViewModel>(context, listen: false)
          .openSession(this.login[0].message, context);
      showMessage(context, 'Verifikasi Kode Rahasi Sukses');
      Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
    } else {
      showMessage(context, 'Verifikasi Kode Rahasi Gagal');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.black87),
          ),
          leading: InkWell(
            onTap: () => pushReplacement(
                context,
                OtpLoginPage(
                  phone: widget.phone,
                )),
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
                indicatorType: Indicator.circleStrokeSpin,
                color: jagoRed,
              ),
            ),
          ),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: [
                  SizedBox(height: 30),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: FlareActor(
                      "assets/otp.flr",
                      animation: "otp",
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Verifikasi Nomor Anda',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8),
                    child: RichText(
                      text: TextSpan(
                          text: "Masukan kode yang dikirim ke ",
                          children: [
                            TextSpan(
                                text: widget.phone,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ],
                          style:
                              TextStyle(color: Colors.black54, fontSize: 15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          obscureText: false,
                          obscuringCharacter: '*',
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v.length < 3) {
                              return "Tidak boleh kosong";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 60,
                            fieldWidth: 50,
                            activeFillColor:
                                hasError ? Colors.orange : Colors.white,
                          ),
                          animationDuration: Duration(milliseconds: 300),
                          textStyle: TextStyle(fontSize: 20, height: 1.6),
                          // backgroundColor: Colors.blue.shade50,
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          onCompleted: (v) {
                            checkotp(v);
                            setState(() {
                              isLoading = true;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            return true;
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      hasError
                          ? "*Silahkan masukan kode yang telah kami kirim"
                          : "",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Tidak mendapatkan kode ? ",
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                        children: [
                          TextSpan(
                              text: " Kirim Ulang",
                              recognizer: onTapRecognizer,
                              style: TextStyle(
                                  color: jagoRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16))
                        ]),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
