import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/aksi/aksi_model.dart';
import 'package:jagomart/viewmodels/profil/profil_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoadingStatusProfil {
  completed,
  searching,
  empty,
}

class ProfilListViewModel extends ChangeNotifier {
  LoadingStatusProfil loadingStatus = LoadingStatusProfil.searching;

  List<ProfilViewModel> profil = [];
  List<AksiViewModel> aksi = [];

  String _message;
  String get message => _message;

  Future<void> getprofil() async {
    this.loadingStatus = LoadingStatusProfil.searching;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    List<ProfilModel> newprofil = await Webservice().getProfil(token);

    this.profil = newprofil.map((e) => ProfilViewModel(profil: e)).toList();

    if (this.profil.isEmpty) {
      this.loadingStatus = LoadingStatusProfil.empty;
    } else {
      this.loadingStatus = LoadingStatusProfil.completed;
    }
    notifyListeners();
  }

  Future<void> updateProfil(fullname, gender, email, address) async {
    this.loadingStatus = LoadingStatusProfil.searching;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    List<AksiModel> newprofil = await Webservice()
        .updateProfil(token, fullname, gender, email, address);

    this.aksi = newprofil.map((e) => AksiViewModel(aksi: e)).toList();
    if (this.aksi.isEmpty) {
      this.loadingStatus = LoadingStatusProfil.empty;
    } else {
      this.loadingStatus = LoadingStatusProfil.completed;
    }
    _message = this.aksi[0].message;

    notifyListeners();
  }

  Future<void> updateProfilonAvatar(
      fullname, gender, email, address, avatar) async {
    this.loadingStatus = LoadingStatusProfil.searching;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    List<AksiModel> newprofil = await Webservice()
        .updateProfilOnAvatar(token, fullname, gender, email, address, avatar);

    this.aksi = newprofil.map((e) => AksiViewModel(aksi: e)).toList();
    _message = this.aksi[0].message;

    notifyListeners();
  }
}
