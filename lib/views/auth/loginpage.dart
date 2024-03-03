import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/helpers/loading.dart';
import 'package:jagomart/helpers/toast.dart';
import 'package:jagomart/viewmodels/auth/login_bloc.dart';
import 'package:jagomart/views/auth/registrasipage.dart';

import 'otplogin.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AsyncPhoneFormBloc(),
      child: Builder(
        builder: (context) {
          // ignore: close_sinks
          final formBloc = BlocProvider.of<AsyncPhoneFormBloc>(context);
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            body: FormBlocListener<AsyncPhoneFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                pushReplacement(
                    context,
                    OtpLoginPage(
                      phone: state.successResponse,
                    ));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                showMessage(context, state.failureResponse);
              },
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFff75cc),
                            Color(0xFFff75a3),
                            Color(0xFFb5023e),
                            Color(0xFFc40031),
                          ],
                          stops: [0.1, 0.4, 0.7, 0.9],
                        )),
                      ),
                      Container(
                          height: double.infinity,
                          child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 100.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.all(10.0), // borde width
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200], // border color
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        child: ClipOval(
                                            child: Image.asset(
                                          'images/logo.png',
                                          width: 102.0,
                                          height: 102.0,
                                        )),
                                        radius: 50.0,
                                      ),
                                    ),
                                    Text(
                                      'Masukan Nomor Ponsel Anda',
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: TextFieldBlocBuilder(
                                            textFieldBloc: formBloc.phone,
                                            suffixButton:
                                                SuffixButton.asyncValidating,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                                labelText: 'Nomor Ponsel',
                                                labelStyle: GoogleFonts.lato(
                                                  color: Colors.white54,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    color: Colors.white
                                                        .withOpacity(.5),
                                                    width: .8,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    color: Colors.white
                                                        .withOpacity(.5),
                                                    width: .8,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    color: Colors.white
                                                        .withOpacity(.5),
                                                    width: .8,
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    color: Colors.white
                                                        .withOpacity(.5),
                                                    width: .8,
                                                  ),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    color: Colors.white
                                                        .withOpacity(.5),
                                                    width: .8,
                                                  ),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 5.0),
                                                prefixIcon: Icon(
                                                  Icons.phone_android,
                                                  color: Colors.white,
                                                ),
                                                hintText:
                                                    'Masukan Nomor Ponsel Anda',
                                                hintStyle: TextStyle(
                                                    color: Colors.white54),
                                                errorStyle: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                        AutoSizeText(
                                          '* Format Nomor Telp : 081XXXXXXXXX',
                                          style: GoogleFonts.lato(
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15.0),
                                      width: double.infinity,
                                      child: RaisedButton(
                                        elevation: 5.0,
                                        onPressed: formBloc.submit,
                                        padding: EdgeInsets.all(15.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        color: Colors.white,
                                        child: Text(
                                          'Verifikasi Nomor',
                                          style: TextStyle(
                                            color: Color(0xFF527DAA),
                                            // letterSpacing: 1.5,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => pushReplacement(
                                          context, RegistrasiPage()),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Belum Punya Akun ? ',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Registrasi',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ])))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
