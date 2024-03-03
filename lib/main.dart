import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/menu.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:jagomart/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared
      .init("79e1181e-a664-4c21-814a-9a8a1cb97ccb", iOSSettings: null);
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LokasiListViewModel()),
            ChangeNotifierProvider(create: (_) => AuthListViewModel()),
            ChangeNotifierProvider(create: (_) => SaldoListViewModel()),
            ChangeNotifierProvider(create: (_) => BannerListViewModel()),
            ChangeNotifierProvider(create: (_) => CartListViewModel()),
            ChangeNotifierProvider(create: (_) => ProfilListViewModel()),
            ChangeNotifierProvider(create: (_) => TermsListViewModel()),
            ChangeNotifierProvider(create: (_) => KategoriListViewModel()),
            ChangeNotifierProvider(create: (_) => CommentListViewModel()),
          ],
          child: MaterialApp(
            color: Colors.white,
            title: 'Jago Mart',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                backgroundColor: Colors.white,
                hintColor: Colors.white,
                primaryColor: Colors.red,
                accentColor: Color(0xFFb5043f),
                appBarTheme: AppBarTheme(
                  elevation: 1,
                  color: Colors.white,
                  textTheme: Theme.of(context).textTheme,
                  iconTheme: Theme.of(context).iconTheme,
                ),
                fontFamily: "google"),
            home: Splashscreen(),
            routes: <String, WidgetBuilder>{
              '/menu': (context) => MenuPage(),
            },
          )),
    );
  }
}
