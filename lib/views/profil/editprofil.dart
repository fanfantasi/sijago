import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/loading.dart';
import 'package:jagomart/viewmodels/profil/profil_bloc.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:themify_flutter/themify_flutter.dart';

class EditProfilPage extends StatefulWidget {
  final avatar;
  EditProfilPage({@required this.avatar});
  @override
  _EditProfilPageState createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final picker = ImagePicker();
  File _imageFile;

  @override
  void initState() {
    super.initState();
  }

  void _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Photo Profil",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Ambil dari galeri"),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            var image = await picker.getImage(source: ImageSource.gallery);
            setState(() {
              _imageFile = File(image.path);
            });
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Ambil Photo"),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            var image = await picker.getImage(source: ImageSource.camera);
            setState(() {
              _imageFile = File(image.path);
            });
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Batal"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Future<void> sendData(fullname, gender, email, address) async {
    var vp = Provider.of<ProfilListViewModel>(context, listen: false);

    if (_imageFile != null) {
      vp.updateProfilonAvatar(
          fullname, gender, email, address, _imageFile.path);
    } else {
      vp.updateProfil(fullname, gender, email, address);
    }
    Fluttertoast.showToast(
        msg: vp.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 14.0);
    Navigator.of(context).pop(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profil',
          style: GoogleFonts.lato(),
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => EditProfilFormBloc(),
          child: Builder(builder: (context) {
            // ignore: close_sinks
            final formBloc = BlocProvider.of<EditProfilFormBloc>(context);
            return FormBlocListener<EditProfilFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) async {
                LoadingDialog.hide(context);
                SweetAlert.show(context,
                    subtitle: "Apakah yakin ?...",
                    style: SweetAlertStyle.confirm,
                    confirmButtonText: 'Ya',
                    confirmButtonColor: jagoRed,
                    cancelButtonText: 'Tidak',
                    showCancelButton: true, onPress: (bool isConfirm) {
                  if (isConfirm) {
                    SweetAlert.show(context,
                        subtitle: "Mengirim Data Profil",
                        style: SweetAlertStyle.loading);
                    new Future.delayed(new Duration(milliseconds: 200),
                        () async {
                      var res = json.decode(state.successResponse);
                      await sendData(res['fullname'], res['gender'],
                          res['email'], res['address']);
                      Navigator.of(context).pop(1);
                    });
                  } else {
                    Navigator.of(context).pop(1);
                  }
                  return false;
                });
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
              child: BlocBuilder<EditProfilFormBloc, FormBlocState>(
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 5, right: 8, bottom: 8),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 65,
                                  backgroundColor: Colors.grey.shade400,
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: 170,
                                      height: 170,
                                      child: (_imageFile == null)
                                          ? widget.avatar == null
                                              ? Image.asset(
                                                  'images/logo.png',
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  widget.avatar,
                                                  fit: BoxFit.cover,
                                                )
                                          : Image.file(
                                              _imageFile,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 80,
                                  right: 0,
                                  child: FloatingActionButton(
                                      heroTag: 'avatar',
                                      backgroundColor: Colors.grey,
                                      child: Icon(Icons.camera_alt),
                                      mini: true,
                                      onPressed: _onCameraClick),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: TextFieldBlocBuilder(
                              textFieldBloc: formBloc.phone,
                              isEnabled: false,
                              style: new TextStyle(
                                  fontSize: 14.0, color: Colors.black87),
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
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 5.0),
                                  prefixIcon: Icon(
                                    Themify.mobile,
                                    color: Colors.black54,
                                  ),
                                  hintText: 'Masukan Nomor Handphone Anda',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  errorStyle: TextStyle(color: Colors.black54)),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: TextFieldBlocBuilder(
                              textFieldBloc: formBloc.email,
                              style: new TextStyle(
                                  fontSize: 14.0, color: Colors.black87),
                              decoration: InputDecoration(
                                  labelText: 'Email Anda',
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
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 5.0),
                                  prefixIcon: Icon(
                                    Themify.email,
                                    color: Colors.black54,
                                  ),
                                  hintText: 'Masukan Email Anda',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  errorStyle: TextStyle(color: Colors.black54)),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: TextFieldBlocBuilder(
                              textFieldBloc: formBloc.name,
                              style: new TextStyle(
                                  fontSize: 14.0, color: Colors.black87),
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
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 5.0),
                                  prefixIcon: Icon(
                                    Themify.user,
                                    color: Colors.black54,
                                  ),
                                  hintText: 'Masukan Nama Lengkap Anda',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  errorStyle: TextStyle(color: Colors.black54)),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: RadioButtonGroupFieldBlocBuilder(
                              selectFieldBloc: formBloc.gender,
                              itemBuilder: (context, value) => value,
                              decoration: InputDecoration(
                                labelText: 'Jenis Kelamin',
                                labelStyle: TextStyle(
                                  color: Colors.black54,
                                ),
                                prefixIcon: SizedBox(),
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
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: TextFieldBlocBuilder(
                              textFieldBloc: formBloc.address,
                              style: new TextStyle(
                                  fontSize: 14.0, color: Colors.black87),
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
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 5.0),
                                  prefixIcon: Icon(
                                    Themify.location_pin,
                                    color: Colors.black54,
                                  ),
                                  hintText: 'Masukan Alamat Lengkap Anda',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  errorStyle: TextStyle(color: Colors.black54)),
                              maxLines: 3,
                              maxLength: 200,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              height: 40,
                              child: FlatButton(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(color: jagoRed),
                                  ),
                                  child:
                                      Text("Simpan", style: GoogleFonts.lato()),
                                  onPressed: formBloc.submit),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
