import 'package:auto_size_text/auto_size_text.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/favorit/favorit.dart';
import 'package:jagomart/views/news.dart';
import 'package:jagomart/views/home.dart';
import 'package:jagomart/views/pesan.dart';
import 'package:jagomart/views/profil.dart';
import 'package:jagomart/views/signout.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _requireConsent = false;
  String debugLabelString = "";
  int selectedPage = 2;

  AppUpdateInfo updateInfo;
  bool flexibleUpdateAvailable = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    await InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        updateInfo = info;
      });
    }).catchError((e) => _showError(e));
  }

  void _showError(dynamic exception) {
    _scaffoldKey.currentState
        // ignore: deprecated_member_use
        .showSnackBar(SnackBar(content: Text(exception.toString())));
  }

  @override
  void initState() {
    super.initState();
    checkForUpdate();

    checkForAndroidUpdate();
  }

  Future<void> checkForAndroidUpdate() async {
    await InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        updateInfo = info;
      });
      if (updateInfo?.updateAvailable == true) {
        _showAndroidUpdateDialogPage(context);
      }
    });
  }

  /// COONECTION DIALOG
  _showAndroidUpdateDialogPage(context) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: AlertDialog(
              //elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              actions: <Widget>[
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                    InAppUpdate.performImmediateUpdate();
                  },
                  child: Text(
                    "Perbaharui",
                    style: GoogleFonts.lato(),
                  ),
                ),
              ],
              title: Text(
                "Notifikasi Pembaharuan",
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              content: Text(
                  'Versi terbaru aplikasi tersedia. Demi kenyamanan Anda perlu memperbarui aplikasi ini.',
                  style: GoogleFonts.lato(color: Colors.red)),
            ),
          );
        });
  }

  void _incrementTab(index) {
    setState(() {
      selectedPage = index;
    });
  }

  Future<bool> onWillPop() async {
    if (selectedPage != 2) {
      setState(() {
        selectedPage = 2;
      });
    } else {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Apakah yakin?'),
              content: new Text('Apakah ingin keluar dari aplikasi sekarang'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('Tidak'),
                ),
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Ya'),
                ),
              ],
            ),
          )) ??
          false;
    }
    return null;
  }

  void initOneSignal() {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print("OPENED NOTIFICATION");
      print(result.notification.jsonRepresentation().replaceAll("\\n", "\n"));
      this.setState(() {
        debugLabelString =
            "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  Widget _pages(AuthListViewModel vs) {
    switch (vs.loadingStatus) {
      case LoadingStatusAuth.signout:
        return IndexedStack(
          index: selectedPage,
          children: [
            NewsPage(),
            SignOutPage(),
            HomePage(),
            SignOutPage(),
            SignOutPage()
          ],
        );
      case LoadingStatusAuth.signin:
        return IndexedStack(
          index: selectedPage,
          children: [
            NewsPage(),
            FavoritPage(),
            HomePage(),
            PesanPage(),
            ProfilPage()
          ],
        );

      default:
        return IndexedStack(
          index: selectedPage,
          children: [
            SignOutPage(),
            SignOutPage(),
            HomePage(),
            SignOutPage(),
            SignOutPage()
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    var va = Provider.of<AuthListViewModel>(context);
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: _pages(va),
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: selectedPage,
            onTap: _incrementTab,
            color: Colors.white,
            backgroundColor: Colors.blueGrey[50],
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 200),
            height: 50,
            items: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/feeds.png',
                    fit: BoxFit.contain,
                    height: 24,
                  ),
                  Text('Feeds',
                      style: GoogleFonts.abel(color: jagoRed, fontSize: 14))
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/favorite.png',
                    fit: BoxFit.contain,
                    height: 24,
                  ),
                  AutoSizeText(
                    'Favorit',
                    textAlign: TextAlign.center,
                    maxFontSize: 14,
                    style: GoogleFonts.abel(color: jagoRed, fontSize: 14),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.asset(
                  'images/store.png',
                  fit: BoxFit.contain,
                  height: 32,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/cart.png',
                      fit: BoxFit.contain,
                      height: 24,
                    ),
                    Text(
                      'Pesan',
                      style: GoogleFonts.abel(color: jagoRed, fontSize: 14),
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/profil.png',
                    fit: BoxFit.contain,
                    height: 24,
                  ),
                  Text(
                    'Profil',
                    style: GoogleFonts.abel(color: jagoRed, fontSize: 14),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
