import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/viewmodels/alamat/alamat_model.dart';
import 'package:jagomart/viewmodels/alamat/alamat_view_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/alamat/add_alamat.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:themify_flutter/themify_flutter.dart';

class AlamatPage extends StatefulWidget {
  @override
  _AlamatPageState createState() => _AlamatPageState();
}

class _AlamatPageState extends State<AlamatPage> {
  ScrollController _scrollViewController = new ScrollController();
  final alamatBloc = AlamatBloc();

  @override
  void initState() {
    alamatBloc.getalamat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alamat',
          style: GoogleFonts.lato(),
        ),
      ),
      body: StreamBuilder(
        stream: alamatBloc.alamatStream,
        builder: (context, AsyncSnapshot<List<AlamatViewModel>> snapshot) {
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

              return SingleChildScrollView(
                  controller: _scrollViewController,
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5.0,
                        ),
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
                              Text('Berikut adalah Alamat anda.')
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, i) {
                            return _AddressView(
                              list: snapshot.data[i],
                              index: i,
                              alamatBloc: alamatBloc,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Container(
                            height: 40,
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: jagoRed),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Themify.plus, color: jagoRed),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text("Tambah alamat baru",
                                      style: GoogleFonts.lato()),
                                ],
                              ),
                              onPressed: () async {
                                _navigateAndDisplaySelection(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
          }
        },
      ),
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAlamatPage()),
    );
    if (result == 1) {
      alamatBloc.getalamat();
    }
  }
}

class _AddressView extends StatefulWidget {
  final AlamatViewModel list;
  final index;
  final AlamatBloc alamatBloc;
  _AddressView({this.list, this.index, this.alamatBloc});

  @override
  __AddressViewState createState() => __AddressViewState();
}

class __AddressViewState extends State<_AddressView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('alamat', widget.list.address);
            await prefs.setString('deliverid', widget.list.id);
            await prefs.setDouble('latitude', widget.list.location.latitude);
            await prefs.setDouble('longitude', widget.list.location.longitude);
            await prefs.setString('imgmap', widget.list.map);
            Navigator.of(context).pop(1);
          },
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                                image: NetworkImage(
                                  widget.list.map,
                                ),
                                fit: BoxFit.cover)),
                      ),
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              '${widget.list.fullname}',
                              maxFontSize: 14,
                              minFontSize: 12,
                              style: GoogleFonts.lato(),
                            ),
                            InkWell(
                              onTap: () {
                                SweetAlert.show(context,
                                    subtitle: "Apakah yakin kak.",
                                    style: SweetAlertStyle.confirm,
                                    cancelButtonText: 'Tidak',
                                    confirmButtonText: 'Ya',
                                    confirmButtonColor: jagoRed,
                                    showCancelButton: true,
                                    onPress: (bool isConfirm) {
                                  if (isConfirm) {
                                    SweetAlert.show(context,
                                        subtitle: "Hapus Alamat...",
                                        style: SweetAlertStyle.loading);
                                    new Future.delayed(
                                        new Duration(milliseconds: 200),
                                        () async {
                                      await widget.alamatBloc
                                          .deletedalamat(widget.list.id);
                                      widget.alamatBloc.getalamat();
                                      Provider.of<CartListViewModel>(context,
                                              listen: false)
                                          .getalamat();
                                      Navigator.of(context).pop();
                                    });
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                  return false;
                                });
                              },
                              child: AutoSizeText(
                                'Hapus',
                                maxFontSize: 14,
                                minFontSize: 12,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 14.0),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.green,
                                size: 16,
                              ),
                              AutoSizeText('${widget.list.phone}',
                                  maxFontSize: 12,
                                  minFontSize: 11,
                                  style: GoogleFonts.lato()),
                            ],
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: AutoSizeText('${widget.list.address}',
                            maxFontSize: 12,
                            minFontSize: 11,
                            style:
                                GoogleFonts.lato(fontStyle: FontStyle.italic)),
                      )
                    ],
                  )
                ],
              ),
              Divider()
            ],
          ),
        ));
  }
}
