import 'package:flutter/widgets.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/kategori/kategori_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoadingStatus {
  completed,
  searching,
  empty,
}

class KategoriListViewModel extends ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  List<KategoriViewModel> kategori = [];

  Future<void> getkategori() async {
    this.loadingStatus = LoadingStatus.searching;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    List<KategoriModel> newkategori = await Webservice().getKategori(token);

    this.kategori =
        newkategori.map((e) => KategoriViewModel(kategori: e)).toList();

    if (this.kategori.isEmpty) {
      this.loadingStatus = LoadingStatus.empty;
    } else {
      this.loadingStatus = LoadingStatus.completed;
    }

    notifyListeners();
  }
}
