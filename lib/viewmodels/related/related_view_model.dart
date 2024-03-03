import 'dart:async';

import 'package:jagomart/config/web_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/helpers/distance.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/viewmodels/related/related_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RelatedBloc {
  String distance = '0 KM';
  List<RelatedModel> newItems = [];
  List<RelatedViewModel> items = [];
  final StreamController<List<RelatedViewModel>> _itemsController =
      StreamController<List<RelatedViewModel>>();
  Stream<List<RelatedViewModel>> get relatedStream => _itemsController.stream;

  void dispose() async {
    await relatedStream.drain();
    _itemsController.close();
  }

  Future<void> getRelatedTop(int start, String location, String tags) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<RelatedModel> newpromo =
          await Webservice().getRelated(token, start, location, tags);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      this.items =
          this.newItems.map((e) => RelatedViewModel(items: e)).toList();
      _itemsController.sink.add(this.items);
    } catch (e) {
      _itemsController.sink.addError(e);
    }
  }

  Future<void> getRelated(int start, String location, String tags) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<RelatedModel> newpromo =
          await Webservice().getRelated(token, start, location, tags);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      var items = this.newItems.map((e) => RelatedViewModel(items: e)).toList();
      this.items.addAll(items);
      _itemsController.sink.add(this.items);
    } catch (e) {
      _itemsController.sink.addError(e);
    }
  }
}
