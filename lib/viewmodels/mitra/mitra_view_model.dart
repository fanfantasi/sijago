import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/helpers/distance.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/mitra/mitra_model.dart';
import 'package:rxdart/rxdart.dart';

class MitraBloc {
  String distance = '0 KM';
  List<MitraModel> newMitra = [];
  List<MitraViewModel> mitra = [];
  final StreamController<List<MitraViewModel>> _mitraController =
      BehaviorSubject();
  Stream<List<MitraViewModel>> get mitraStream => _mitraController.stream;

  void dispose() async {
    await mitraStream.drain();
    _mitraController.close();
  }

  Future<void> getMitraTop(int start, String location) async {
    try {
      List<MitraModel> newmitra = await Webservice().getMitra(start, location);
      this.newMitra = newmitra;
      for (int i = 0; i < this.newMitra.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newMitra[i].location);
        this.newMitra[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      this.mitra = newmitra.map((e) => MitraViewModel(mitra: e)).toList();
      _mitraController.sink.add(this.mitra);
    } catch (e) {
      _mitraController.sink.addError(e);
    }
  }

  Future<bool> getMitra(int start, String location) async {
    try {
      List<MitraModel> newmitra = await Webservice().getMitra(start, location);
      this.newMitra = newmitra;
      for (int i = 0; i < this.newMitra.length; i++) {
        var _distance = await CalculateDistance().calculateDistance(
            LatLng(Config.mylocation.latitude, Config.mylocation.longitude),
            this.newMitra[i].location);
        this.newMitra[i].distance = double.parse(_distance).toStringAsFixed(2);
      }
      var mitras = newMitra.map((e) => MitraViewModel(mitra: e)).toList();
      this.mitra.addAll(mitras);
      if (mitras.isEmpty) {
        return false;
      } else {
        _mitraController.sink.add(this.mitra);

        return true;
      }
    } catch (e) {
      _mitraController.sink.addError(e);
    }

    return null;
  }
}
