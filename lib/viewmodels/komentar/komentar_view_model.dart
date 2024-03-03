import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/komentar/komentar_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoadingStatusKomentar {
  completed,
  searching,
  empty,
}

class CommentListViewModel extends ChangeNotifier {
  LoadingStatusKomentar loadingStatus = LoadingStatusKomentar.searching;

  List<KomentarViewModel> komentar = [];
  List<KomentarViewModel> newkomentar = [];

  Future<void> getcomment(int start, newsid) async {
    this.loadingStatus = LoadingStatusKomentar.searching;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      try {
        this.komentar.clear();
        List<ModelComment> newnews =
            await Webservice().getcomment(token, start, newsid);
        this.komentar =
            newnews.map((e) => KomentarViewModel(komentar: e)).toList();
        if (this.komentar.isEmpty) {
          this.loadingStatus = LoadingStatusKomentar.empty;
        } else {
          this.loadingStatus = LoadingStatusKomentar.completed;
        }
      } catch (e) {
        this.loadingStatus = LoadingStatusKomentar.empty;
      }
    } else {
      this.loadingStatus = LoadingStatusKomentar.empty;
      Fluttertoast.showToast(
          msg: "Silahkan login terlebih dahulu",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          fontSize: 14.0);
    }

    notifyListeners();
  }

  Future<KomentarViewModel> insertComment(newsid, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    List<ModelComment> newcomment =
        await Webservice().getinitcomment(token, newsid, value);
    this.newkomentar =
        newcomment.map((e) => KomentarViewModel(komentar: e)).toList();
    return this.newkomentar[0];
  }

  void addComment(KomentarViewModel value) async {
    this.komentar.insert(0, value);
    notifyListeners();
  }
}
