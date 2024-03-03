import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/views/auth/loginpage.dart';
import 'package:jagomart/views/auth/registrasipage.dart';
import 'package:themify_flutter/themify_flutter.dart';

class SignOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 0),
              )
            ], color: Colors.white),
            height: 60.0,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Themify.lock,
                        color: jagoRed,
                        size: 24,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'LOGIN AREA',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 18.0, color: jagoRed),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.01,
                height: MediaQuery.of(context).size.height / 1.5,
                child: FlareActor(
                  "assets/signin.flr",
                  animation: "go",
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
              ),
              Positioned(
                top: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: AutoSizeText(
                        'Anda Belum Login',
                        textAlign: TextAlign.center,
                        style:
                            GoogleFonts.aclonica(color: jagoRed, fontSize: 18),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: AutoSizeText(
                        'Silahkan login terlebih dahulu.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aclonica(
                            color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 50,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: FlatButton(
                          onPressed: () {
                            push(context, LoginPage());
                          },
                          padding: EdgeInsets.all(15.0),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                            side: BorderSide(color: Colors.green),
                          ),
                          color: Colors.white,
                          child: AutoSizeText('Masuk',
                              style: GoogleFonts.lato(
                                color: Colors.green,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: FlatButton(
                          onPressed: () {
                            push(context, RegistrasiPage());
                          },
                          padding: EdgeInsets.all(15.0),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                            side: BorderSide(color: jagoRed),
                          ),
                          color: Colors.white,
                          child: AutoSizeText('Daftar',
                              style: GoogleFonts.lato(
                                color: jagoRed,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      )),
    );
  }
}
