import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/helpers/distance.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/items/items_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBloc {
  String distance = '0 KM';
  List<ItemsModel> newItems = [];
  List<ItemsViewModel> items = [];
  final StreamController _searchController =
      StreamController<List<ItemsViewModel>>();
  Stream<List<ItemsViewModel>> get searchStream => _searchController.stream;

  void dispose() async {
    await searchStream.drain();
    _searchController.close();
  }

  Future<void> getSearchTop(int start, String location, String search) async {
    try {
      _searchController.sink.add(null);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      this.items.clear();
      List<ItemsModel> newpromo =
          await Webservice().getSearchItems(token, start, location, search);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      this.items = newItems.map((e) => ItemsViewModel(items: e)).toList();
      _searchController.sink.add(this.items);
    } catch (e) {
      _searchController.sink.addError(e);
    }
  }

  Future<bool> getSearch(int start, String location, String search) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<ItemsModel> newpromo =
          await Webservice().getSearchItems(token, start, location, search);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      var items = newItems.map((e) => ItemsViewModel(items: e)).toList();
      this.items.addAll(items);
      if (items.isEmpty) {
        return false;
      } else {
        _searchController.sink.add(this.items);
        return true;
      }
    } catch (e) {
      _searchController.sink.addError(e);
    }
    return false;
  }
}
