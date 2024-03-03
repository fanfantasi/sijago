import 'package:flutter/widgets.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/banner/banner_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoadingStatusBanner {
  completed,
  searching,
  empty,
}

class BannerListViewModel extends ChangeNotifier {
  LoadingStatusBanner loadingStatus = LoadingStatusBanner.searching;

  List<BannerViewModel> banner = [];

  void getbanner() async {
    this.loadingStatus = LoadingStatusBanner.searching;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    List<BannersModel> newbanner = await Webservice().getBanner(token);

    this.banner = newbanner.map((e) => BannerViewModel(banner: e)).toList();

    if (this.banner.isEmpty) {
      this.loadingStatus = LoadingStatusBanner.empty;
    } else {
      this.loadingStatus = LoadingStatusBanner.completed;
    }

    notifyListeners();
  }
}
