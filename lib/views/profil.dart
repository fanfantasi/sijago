import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/formatter.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/profil/profil_view_model.dart';
import 'package:jagomart/viewmodels/saldo/saldo_view_model.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/profil/editprofil.dart';
import 'package:jagomart/views/terms/terms.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:themify_flutter/themify_flutter.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final double circleRadius = 100.0;
  final double circleBorderWidth = 8.0;
  bool isLoading = false;
  String avatar;

  @override
  void initState() {
    Provider.of<SaldoListViewModel>(context, listen: false).getsaldo();
    Provider.of<ProfilListViewModel>(context, listen: false).getprofil();
    super.initState();
  }

  Widget _profil(ProfilListViewModel vp) {
    switch (vp.loadingStatus) {
      case LoadingStatusProfil.searching:
        return Center(
          child: Container(
            color: Colors.transparent,
            width: 55,
            height: 55,
            padding: EdgeInsets.all(12.0),
            child: LoadingIndicator(
              indicatorType: Indicator.circleStrokeSpin,
              color: Theme.of(context).primaryColor,
            ),
          ),
        );
      case LoadingStatusProfil.completed:
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: circleRadius / 2.0, left: 10.0, right: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: jagoRed.withOpacity(0.6),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                height: 100.0,
              ),
            ),
            Container(
              width: circleRadius,
              height: circleRadius,
              decoration:
                  ShapeDecoration(shape: CircleBorder(), color: Colors.black12),
              child: Padding(
                padding: EdgeInsets.all(circleBorderWidth),
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                      shape: CircleBorder(),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            vp.profil[0].avatar,
                          ))),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: circleRadius),
              child: Column(
                children: <Widget>[
                  AutoSizeText("${vp.profil[0].fullname}",
                      maxLines: 2,
                      maxFontSize: 16,
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  AutoSizeText(
                    "${vp.profil[0].phone}",
                    maxLines: 2,
                    maxFontSize: 14,
                    style: GoogleFonts.lato(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        );
      case LoadingStatusProfil.empty:
      default:
        return Container();
    }
  }

  //Saldo
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
            maxFontSize: 14, minFontSize: 10, style: GoogleFonts.lato());
    }
  }

  @override
  Widget build(BuildContext context) {
    var vp = Provider.of<ProfilListViewModel>(context);
    var vs = Provider.of<SaldoListViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                        Image.asset(
                          'images/profil.png',
                          fit: BoxFit.contain,
                          height: 24,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Profil',
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
              child: RefreshIndicator(
                onRefresh: _refreshProfil,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      _profil(vp),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: jagoRed,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
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
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: AutoSizeText(
                                          'Saldo',
                                          style: GoogleFonts.lato(
                                              color: jagoWhite),
                                        ))
                                  ],
                                ),
                                _saldo(vs)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 20.0),
                        child: Text('Profil',
                            style: GoogleFonts.lato(fontSize: 16.0)),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                _navigateAndDisplaySelection(context, vp);
                              },
                              child: ListTile(
                                leading: Image.asset(
                                  'images/profil.png',
                                  fit: BoxFit.contain,
                                  height: 24,
                                ),
                                title: Text('Ubah Profil',
                                    style: GoogleFonts.lato(fontSize: 16.0)),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                Share.share(
                                    'Selamat datang di Aplikasi Si Jago Mitranya UMKM, Silahkan bergabung bersama kami dan cek produk-produk terbaik kami di https://play.google.com/store/apps/details?id=com.jago.sijago');
                              },
                              child: ListTile(
                                leading: Icon(
                                  Themify.comments_smiley,
                                  color: Colors.green,
                                ),
                                title: Text('Share Aplikasi',
                                    style: GoogleFonts.lato(fontSize: 16.0)),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                final string = Config.phonecabang;
                                final replase =
                                    string.replaceFirst(RegExp('0'), '+62');
                                FlutterOpenWhatsapp.sendSingleMessage(
                                    "$replase", "Hallo Kak.");
                              },
                              child: ListTile(
                                leading: Icon(
                                  Themify.headphone_alt,
                                  color: Colors.redAccent,
                                  size: 18,
                                ),
                                title: Text('Customer Service'),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Text(
                          'Tentang Kami',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                push(
                                    context,
                                    TermsPage(
                                      title: 'Keuntungan Pake Jago',
                                      field: 'keuntungan',
                                    ));
                              },
                              child: ListTile(
                                leading: Icon(Themify.thumb_up,
                                    color: Colors.pinkAccent),
                                title: Text('Keuntungan Pake JAGO'),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                push(
                                    context,
                                    TermsPage(
                                      title: 'Panduan',
                                      field: 'panduan',
                                    ));
                              },
                              child: ListTile(
                                leading: Icon(Themify.info_alt,
                                    color: Colors.pinkAccent),
                                title: Text('Panduan'),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                push(
                                    context,
                                    TermsPage(
                                      title: 'Syarat dan Ketentuan',
                                      field: 'syarat_ketentuan',
                                    ));
                              },
                              child: ListTile(
                                leading: Icon(Themify.help_alt,
                                    color: Colors.pinkAccent),
                                title: Text('Syarat dan Ketentuan'),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                push(
                                    context,
                                    TermsPage(
                                      title: 'Kebijakan Privasi',
                                      field: 'kebijakan_privasi',
                                    ));
                              },
                              child: ListTile(
                                leading: Icon(Themify.infinite,
                                    color: Colors.pinkAccent),
                                title: Text('Kebijakan Privasi'),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                push(
                                    context,
                                    TermsPage(
                                      title: 'Pusat Bantuan',
                                      field: 'pusat_bantuan',
                                    ));
                              },
                              child: ListTile(
                                leading: Icon(
                                  Themify.headphone,
                                  color: Colors.pinkAccent,
                                ),
                                title: Text('Pusat Bantuan'),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                push(
                                    context,
                                    TermsPage(
                                      title: 'Cara Daftar Jago Ads',
                                      field: 'jago_ads',
                                    ));
                              },
                              child: ListTile(
                                leading: Icon(
                                  Themify.headphone_alt,
                                  color: Colors.pinkAccent,
                                ),
                                title: Text('Jago Ads'),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Versi',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '5.1.3.16',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      Container(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              SweetAlert.show(context,
                                  title: 'Keluar',
                                  subtitle: 'Apakah yakin akan keluar?..',
                                  style: SweetAlertStyle.confirm,
                                  cancelButtonText: 'Tidak',
                                  confirmButtonText: 'Ya',
                                  confirmButtonColor: jagoRed,
                                  showCancelButton: true,
                                  onPress: (bool confirm) {
                                if (confirm) {
                                  SweetAlert.show(
                                    context,
                                    style: SweetAlertStyle.loading,
                                    title: "Keluar dari aplikasi...",
                                  );
                                  Future.delayed(Duration(microseconds: 200),
                                      () async {
                                    Provider.of<AuthListViewModel>(context,
                                            listen: false)
                                        .closeSession();
                                    Navigator.of(context).pop();
                                    return false;
                                  });
                                  return false;
                                }
                                return null;
                              });
                            },
                            child: ListTile(
                              title: Text('Keluar'),
                              trailing: Icon(Themify.power_off),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _refreshProfil() async {
    await Provider.of<SaldoListViewModel>(context, listen: false).getsaldo();
    await Provider.of<ProfilListViewModel>(context, listen: false).getprofil();
  }

  _navigateAndDisplaySelection(
      BuildContext context, ProfilListViewModel vp) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditProfilPage(
                avatar: vp.profil[0].avatar,
              )),
    );
    if (result == 1) {
      await Provider.of<SaldoListViewModel>(context, listen: false).getsaldo();
      await Provider.of<ProfilListViewModel>(context, listen: false)
          .getprofil();
    }
  }
}
