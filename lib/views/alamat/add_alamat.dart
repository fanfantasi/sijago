import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/loading.dart';
import 'package:jagomart/viewmodels/alamat/alamat_bloc.dart';
import 'package:jagomart/viewmodels/alamat/alamat_view_model.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:themify_flutter/themify_flutter.dart';

import 'package:jagomart/views/alamat/map.dart';

Uint8List _imageBytes;

class AddAlamatPage extends StatefulWidget {
  @override
  AddAlamatPageState createState() => AddAlamatPageState();
}

class AddAlamatPageState extends State<AddAlamatPage> {
  LatLng initialPosition;
  final alamatBloc = AlamatBloc();

  @override
  void initState() {
    _imageBytes = null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Alamat',
          style: GoogleFonts.lato(),
        ),
      ),
      body: BlocProvider(
          create: (context) => AddressFormBloc(),
          child: Builder(builder: (context) {
            // ignore: close_sinks
            var formBloc = BlocProvider.of<AddressFormBloc>(context);
            return FormBlocListener<AddressFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) async {
                if (initialPosition == null) {
                  LoadingDialog.hide(context);
                  SweetAlert.show(
                    context,
                    title: "Lokasi pengiriman",
                    subtitle: "Lokasi pengiriman belum ditentukan.",
                    confirmButtonColor: jagoRed,
                  );
                } else {
                  String dir = (await getApplicationDocumentsDirectory()).path;
                  File file = File("$dir/" +
                      DateTime.now().millisecondsSinceEpoch.toString() +
                      ".jpg");
                  await file.writeAsBytes(_imageBytes);
                  var res = json.decode(state.successResponse);
                  new Future.delayed(new Duration(milliseconds: 200), () async {
                    await alamatBloc.addalamat(
                        res['nama'],
                        res['phone'],
                        res['address'],
                        '${initialPosition.latitude},${initialPosition.longitude}',
                        file.path);
                    LoadingDialog.hide(context);
                    Navigator.of(context).pop(1);
                  });
                }
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                Fluttertoast.showToast(
                    msg: state.failureResponse,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: jagoRed,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              child: BlocBuilder<AddressFormBloc, FormBlocState>(
                builder: (context, state) {
                  if (state is FormBlocLoading) {
                    return Center(
                        child: Container(
                      width: 65,
                      height: 65,
                      padding: EdgeInsets.all(12.0),
                      child: LoadingIndicator(
                        indicatorType: Indicator.circleStrokeSpin,
                        color: jagoRed,
                      ),
                    ));
                  } else if (state is FormBlocLoadFailed) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Themify.unlink,
                            size: 65,
                            color: Colors.red,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Mohon periksa koneksi internet anda',
                              style: TextStyle(fontSize: 18.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            onPressed: formBloc.reload,
                            child: Text('Ulangi'),
                          )
                        ],
                      ),
                    );
                  } else {
                    return ListView(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 3,
                                height: 20,
                                color: Colors.black87,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text('Tambah alamat baru.'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: TextFieldBlocBuilder(
                                  textFieldBloc: formBloc.phone,
                                  style: GoogleFonts.lato(),
                                  decoration: InputDecoration(
                                      labelText: 'Nomor Ponsel',
                                      labelStyle: TextStyle(
                                        color: Colors.black54,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 5.0),
                                      prefixIcon: Icon(
                                        Themify.mobile,
                                        color: Colors.black54,
                                      ),
                                      hintText: 'Masukan Nomor Handphone Anda',
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
                                      errorStyle:
                                          TextStyle(color: Colors.black54)),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: TextFieldBlocBuilder(
                                  textFieldBloc: formBloc.name,
                                  style: GoogleFonts.lato(),
                                  decoration: InputDecoration(
                                      labelText: 'Nama Lengkap',
                                      labelStyle: TextStyle(
                                        color: Colors.black54,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 5.0),
                                      prefixIcon: Icon(
                                        Themify.user,
                                        color: Colors.black54,
                                      ),
                                      hintText: 'Masukan Nama Lengkap Anda',
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
                                      errorStyle:
                                          TextStyle(color: Colors.black54)),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: TextFieldBlocBuilder(
                                  textFieldBloc: formBloc.alamat,
                                  style: GoogleFonts.lato(),
                                  decoration: InputDecoration(
                                      labelText: 'Alamat Lengkap',
                                      labelStyle: TextStyle(
                                        color: Colors.black54,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.black54.withOpacity(.5),
                                          width: .8,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 5.0),
                                      prefixIcon: Icon(
                                        Themify.location_pin,
                                        color: Colors.black54,
                                      ),
                                      hintText: 'Masukan Alamat Lengkap Anda',
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
                                      errorStyle:
                                          TextStyle(color: Colors.black54)),
                                  maxLines: 2,
                                  maxLength: 200,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _navigateAndDisplaySelection(context);
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 180.0,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          image: (_imageBytes == null)
                                              ? DecorationImage(
                                                  image: AssetImage(
                                                      'images/map.png'),
                                                  fit: BoxFit.cover)
                                              : DecorationImage(
                                                  image:
                                                      MemoryImage(_imageBytes),
                                                  scale: 20,
                                                  fit: BoxFit.cover)),
                                    ),
                                    Positioned(
                                        top: 0.0,
                                        right: 0.0,
                                        left: 0.0,
                                        bottom: 0.0,
                                        child: Container(
                                          height: 20,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color:
                                                  Colors.black.withOpacity(.3)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                              ),
                                              AutoSizeText(
                                                'Lokasi Pengiriman',
                                                maxFontSize: 14,
                                                minFontSize: 12,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  height: 40,
                                  child: FlatButton(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: BorderSide(color: jagoRed),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Themify.plus, color: jagoRed),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text("Tambah alamat baru",
                                              style: GoogleFonts.lato()),
                                        ],
                                      ),
                                      onPressed: formBloc.submit),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                },
              ),
            );
          })),
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final List result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPage()),
    );
    if (result != null) {
      setState(() {
        _imageBytes = result[0];
        initialPosition = result[1];
      });
      print(initialPosition);
    }
  }
}
