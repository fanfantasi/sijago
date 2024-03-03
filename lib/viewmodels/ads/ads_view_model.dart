import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/helpers/distance.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/ads/ads_model.dart';
import 'package:rxdart/rxdart.dart';

class AdsBloc {
  String distance = '0 KM';
  List<AdsModel> newAds = [];
  List<AdsViewModel> ads = [];

  List<AdsModel> newAdsV = [];
  List<AdsViewModel> adsV = [];

  final StreamController<List<AdsViewModel>> _adsController = BehaviorSubject();
  Stream<List<AdsViewModel>> get adsStream => _adsController.stream;

  final StreamController<List<AdsViewModel>> _adsVerticalController =
      BehaviorSubject();
  Stream<List<AdsViewModel>> get adsVerticalStream =>
      _adsVerticalController.stream;

  void dispose() async {
    await adsStream.drain();
    _adsController.close();

    await adsVerticalStream.drain();
    _adsVerticalController.close();
  }

  Future<void> getAdsTop(int start, int posisi, String location) async {
    try {
      List<AdsModel> newads =
          await Webservice().getAds(start, posisi, location);
      // this.newAds = newads;
      for (int i = 0; i < newads.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            newads[i].location);
        if (newads[i].posisi == 1) {
          this.newAdsV.add(AdsModel(
                id: newads[i].id,
                title: newads[i].title,
                distance: double.parse(_distance).toStringAsFixed(2),
                jenis: newads[i].jenis,
                link: newads[i].link,
                image: newads[i].image,
                location: newads[i].location,
                phone: newads[i].phone,
                posisi: newads[i].posisi,
              ));
        } else {
          this.newAds.add(AdsModel(
                id: newads[i].id,
                title: newads[i].title,
                distance: double.parse(_distance).toStringAsFixed(2),
                jenis: newads[i].jenis,
                link: newads[i].link,
                image: newads[i].image,
                location: newads[i].location,
                phone: newads[i].phone,
                posisi: newads[i].posisi,
              ));
        }
      }
      this.ads = this.newAds.map((e) => AdsViewModel(ads: e)).toList();
      _adsController.sink.add(this.ads);

      this.adsV = this.newAdsV.map((e) => AdsViewModel(ads: e)).toList();
      _adsVerticalController.sink.add(this.adsV);
    } catch (e) {
      _adsController.sink.addError(e);
      _adsVerticalController.sink.addError(e);
    }
  }

  Future<bool> getAds(int start, int posisi, String location) async {
    try {
      List<AdsModel> newads =
          await Webservice().getAds(start, posisi, location);
      this.newAds = newads;
      for (int i = 0; i < this.newAds.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newAds[i].location);
        this.newAds[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      var adss = this.newAds.map((e) => AdsViewModel(ads: e)).toList();
      this.ads.addAll(adss);
      if (adss.isEmpty) {
        return false;
      } else {
        _adsController.sink.add(this.ads);

        return true;
      }
    } catch (e) {
      _adsController.sink.addError(e);
    }

    return null;
  }
}
