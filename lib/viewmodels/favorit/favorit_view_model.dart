import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/helpers/distance.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/items/items_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritBloc {
  String distance = '0 KM';
  List<ItemsModel> newItems = [];
  List<ItemsViewModel> items = [];
  final StreamController<List<ItemsViewModel>> _favoritController =
      StreamController<List<ItemsViewModel>>();
  Stream<List<ItemsViewModel>> get favoritStream => _favoritController.stream;

  final StreamController<bool> _favoritbyidController =
      StreamController<bool>.broadcast();
  Stream<bool> get favoritbyidStream => _favoritbyidController.stream;

  void dispose() async {
    await favoritStream.drain();
    _favoritController.close();

    await favoritbyidStream.drain();
    _favoritbyidController.close();
  }

  Future<void> getFavoritTop(int start) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<ItemsModel> newpromo = await Webservice().getFavorit(token, start);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      this.items.clear();
      this.items = this.newItems.map((e) => ItemsViewModel(items: e)).toList();
      this.items.sort((a, b) => a.distance.compareTo(b.distance));
      _favoritController.sink.add(this.items);
    } catch (e) {
      print(e);
      _favoritController.sink.addError(e);
    }
  }

  Future<bool> getFavorit(int start) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<ItemsModel> newpromo = await Webservice().getFavorit(token, start);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      this.items = this.newItems.map((e) => ItemsViewModel(items: e)).toList();
      this.items.sort((a, b) => a.distance.compareTo(b.distance));
      if (items.isEmpty) {
        return false;
      } else {
        _favoritController.sink.add(this.items);
        return true;
      }
    } catch (e) {
      _favoritController.sink.addError(e);
    }

    return null;
  }

  Future<void> getFavoritByid(String itemid, bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      List<AksiModel> newpromo =
          await Webservice().getFavoritByid(token, itemid, status);
      if (newpromo[0].message == "1") {
        _favoritbyidController.sink.add(true);
      } else {
        _favoritbyidController.sink.add(false);
      }
    } catch (e) {
      _favoritbyidController.sink.addError(false);
    }
  }

  Future<void> getUnfavoritByid(String itemid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      List<AksiModel> newpromo =
          await Webservice().getUnfavoritByid(token, itemid);
      if (newpromo[0].message == "1") {
        _favoritbyidController.sink.add(false);
      } else {
        _favoritbyidController.sink.add(true);
      }
    } catch (e) {
      _favoritbyidController.sink.addError(false);
    }
  }
}
