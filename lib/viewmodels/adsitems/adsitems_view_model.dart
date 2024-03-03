import 'dart:async';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/adsitems/adsitems_model.dart';
import 'package:rxdart/rxdart.dart';

class AdsItemsBloc {
  List<AdsItemsViewModel> adsitems = [];

  final StreamController<List<AdsItemsViewModel>> _adsController =
      BehaviorSubject();
  Stream<List<AdsItemsViewModel>> get adsItemsStream => _adsController.stream;

  void dispose() async {
    await adsItemsStream.drain();
    _adsController.close();
  }

  Future<void> getAdsItemsTop(int start, String adsid) async {
    try {
      List<AdsItemsModel> newads = await Webservice().getAdsItems(start, adsid);
      this.adsitems = newads.map((e) => AdsItemsViewModel(ads: e)).toList();
      _adsController.sink.add(this.adsitems);
    } catch (e) {
      _adsController.sink.addError(e);
    }
  }

  Future<bool> getAds(int start, String adsid) async {
    try {
      List<AdsItemsModel> newads = await Webservice().getAdsItems(start, adsid);
      var adss = newads.map((e) => AdsItemsViewModel(ads: e)).toList();
      this.adsitems.addAll(adss);
      if (adss.isEmpty) {
        return false;
      } else {
        _adsController.sink.add(this.adsitems);

        return true;
      }
    } catch (e) {
      _adsController.sink.addError(e);
    }

    return null;
  }
}
