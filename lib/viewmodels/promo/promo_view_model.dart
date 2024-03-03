import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/helpers/distance.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/promo/promo_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromoBloc {
  String distance = '0 KM';
  List<PromoModel> newItems = [];
  List<PromoViewModel> promo = [];
  final StreamController<List<PromoViewModel>> _promoController =
      BehaviorSubject();
  Stream<List<PromoViewModel>> get promoStream => _promoController.stream;

  void dispose() async {
    await promoStream.drain();

    _promoController.close();
  }

  Future<void> getPromo(int start, String location) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<PromoModel> newpromo =
          await Webservice().getPromo(token, start, location);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      var items = newItems.map((e) => PromoViewModel(promo: e)).toList();
      this.promo.addAll(items);
      _promoController.sink.add(this.promo);
    } catch (e) {
      _promoController.sink.addError(e);
    }
  }

  Future<void> getPromoTop(int start, String location) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<PromoModel> newpromo =
          await Webservice().getPromo(token, start, location);
      this.newItems = newpromo;
      for (int i = 0; i < this.newItems.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newItems[i].location);
        this.newItems[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      this.promo = newItems.map((e) => PromoViewModel(promo: e)).toList();
      _promoController.sink.add(this.promo);
    } catch (e) {
      _promoController.sink.addError(e);
    }
  }
}
