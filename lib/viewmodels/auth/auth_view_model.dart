import 'package:flutter/cupertino.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/profil/profil_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoadingStatusAuth {
  signin,
  signout,
}

class AuthListViewModel extends ChangeNotifier {
  LoadingStatusAuth loadingStatus = LoadingStatusAuth.signout;
  List<ProfilViewModel> profil = [];

  Future<void> getProfil() async {
    this.loadingStatus = LoadingStatusAuth.signout;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<ProfilModel> newprofil =
          await Webservice().getProfil(prefs.getString('token'));

      this.profil = newprofil.map((e) => ProfilViewModel(profil: e)).toList();

      if (this.profil.isEmpty) {
        this.loadingStatus = LoadingStatusAuth.signout;
      } else {
        this.loadingStatus = LoadingStatusAuth.signin;
      }
    } catch (e) {
      this.loadingStatus = LoadingStatusAuth.signout;
    }

    print('disini check session');
    notifyListeners();
  }

  Future<void> openSession(String _token, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token);
    await getProfil();

    notifyListeners();
  }

  Future<void> closeSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    await getProfil();
    notifyListeners();
  }

  Future<void> checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      this.loadingStatus = LoadingStatusAuth.signin;
    } else {
      this.loadingStatus = LoadingStatusAuth.signout;
    }

    print('check session');

    notifyListeners();
  }
}
