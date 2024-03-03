import 'dart:async';

import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/bannercategory/bannercategory_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannerKategoriBloc {
  List<BannerCategoryViewModel> banner = [];
  final StreamController<List<BannerCategoryViewModel>> _bannerController =
      StreamController<List<BannerCategoryViewModel>>();
  Stream<List<BannerCategoryViewModel>> get bannerStream =>
      _bannerController.stream;

  void dispose() async {
    await bannerStream.drain();
    _bannerController.close();
  }

  Future<void> getBanner(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<BannerKategoriModel> newpromo =
          await Webservice().getBannerCategory(token, id);
      this.banner =
          newpromo.map((e) => BannerCategoryViewModel(banner: e)).toList();
      _bannerController.sink.add(this.banner);
    } catch (e) {
      _bannerController.sink.addError(e);
    }
  }
}
