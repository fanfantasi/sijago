import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/helpers/distance.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/items/items_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemsBloc {
  String distance = '0 KM';
  List<ItemsModel> newItems = [];
  List<ItemsViewModel> items = [];
  List<ItemsViewModel> itemsmitra = [];
  List<ItemsViewModel> itemscategory = [];
  final StreamController<List<ItemsViewModel>> _itemsController =
      BehaviorSubject();
  Stream<List<ItemsViewModel>> get itemsStream => _itemsController.stream;

  final StreamController<List<ItemsViewModel>> _itemscategoryController =
      BehaviorSubject();
  Stream<List<ItemsViewModel>> get itemscategoryStream =>
      _itemscategoryController.stream;

  final StreamController<List<ItemsViewModel>> _itemsmitraController =
      BehaviorSubject();
  Stream<List<ItemsViewModel>> get itemsmitraStream =>
      _itemsmitraController.stream;

  void dispose() async {
    await itemsStream.drain();
    _itemsController.close();

    await itemscategoryStream.drain();
    _itemscategoryController.close();

    await itemsmitraStream.drain();
    _itemsmitraController.close();
  }

  Future<void> getItemsTop(int start, String location) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<ItemsModel> newpromo =
          await Webservice().getItems(token, start, location);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      this.items = this.newItems.map((e) => ItemsViewModel(items: e)).toList();
      this.items.sort((a, b) => a.distance.compareTo(b.distance));
      _itemsController.sink.add(this.items);
    } catch (e) {
      print(e);
      _itemsController.sink.addError(e);
    }
  }

  Future<bool> getItems(int start, String location) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<ItemsModel> newpromo =
          await Webservice().getItems(token, start, location);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        String _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      var items = this.newItems.map((e) => ItemsViewModel(items: e)).toList();
      this.items.addAll(items);
      if (items.isEmpty) {
        return false;
      } else {
        _itemsController.sink.add(this.items);
        return true;
      }
    } catch (e) {
      _itemsController.sink.addError(e);
    }
    return null;
  }

  Future<void> getItemsCategoryTop(
      int start, String category, String location) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      this.itemscategory.clear();
      List<ItemsModel> newpromo = await Webservice()
          .getItemsByCategory(token, start, category, location);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        String _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      this.itemscategory =
          newItems.map((e) => ItemsViewModel(items: e)).toList();
      _itemscategoryController.sink.add(this.itemscategory);
    } catch (e) {
      _itemscategoryController.sink.addError(e);
    }
  }

  Future<bool> getItemsCategory(
      int start, String category, String location) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<ItemsModel> newpromo = await Webservice()
          .getItemsByCategory(token, start, category, location);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        String _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      var items = newItems.map((e) => ItemsViewModel(items: e)).toList();
      this.itemscategory.addAll(items);
      if (items.isEmpty) {
        return false;
      } else {
        _itemscategoryController.sink.add(this.itemscategory);
        return true;
      }
    } catch (e) {
      _itemscategoryController.sink.addError(e);
    }
    return false;
  }

  Future<void> getItemsMitraTop(int start, String location) async {
    try {
      this.itemsmitra.clear();
      List<ItemsModel> newpromo =
          await Webservice().getItemsMitra(start, location);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        String _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      this.itemsmitra = newItems.map((e) => ItemsViewModel(items: e)).toList();
      _itemsmitraController.sink.add(this.itemsmitra);
    } catch (e) {
      _itemsmitraController.sink.addError(e);
    }
  }

  Future<bool> getItemsMitra(int start, String location) async {
    try {
      List<ItemsModel> newpromo =
          await Webservice().getItemsMitra(start, location);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        String _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      var items = newItems.map((e) => ItemsViewModel(items: e)).toList();
      this.itemsmitra.addAll(items);
      if (items.isEmpty) {
        return false;
      } else {
        _itemsmitraController.sink.add(this.itemsmitra);
        return true;
      }
    } catch (e) {
      _itemsmitraController.sink.addError(e);
    }
    return null;
  }
}
