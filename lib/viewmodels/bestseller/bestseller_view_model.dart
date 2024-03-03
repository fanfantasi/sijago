import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/helpers/distance.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/items/items_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BestSellerBloc {
  String distance = '0 KM';
  List<ItemsModel> newItems = [];
  List<ItemsViewModel> items = [];
  final StreamController<List<ItemsViewModel>> _bestsellerController =
      StreamController<List<ItemsViewModel>>();
  Stream<List<ItemsViewModel>> get bestsellerStream =>
      _bestsellerController.stream;

  void dispose() async {
    await bestsellerStream.drain();
    _bestsellerController.close();
  }

  Future<void> getBestSellerTop(int start, String location) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<ItemsModel> newpromo =
          await Webservice().getBestSeller(token, start, location);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      this.items = this.newItems.map((e) => ItemsViewModel(items: e)).toList();
      _bestsellerController.sink.add(this.items);
    } catch (e) {
      _bestsellerController.sink.addError(e);
    }
  }

  Future<bool> getBestSeller(int start, String location) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<ItemsModel> newpromo =
          await Webservice().getBestSeller(token, start, location);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      var items = this.newItems.map((e) => ItemsViewModel(items: e)).toList();
      this.items.addAll(items);
      if (items.isEmpty) {
        return false;
      } else {
        _bestsellerController.sink.add(this.items);
        return true;
      }
    } catch (e) {
      _bestsellerController.sink.addError(e);
    }
    return null;
  }
}
