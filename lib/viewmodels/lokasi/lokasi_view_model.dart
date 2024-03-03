import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/helpers/distance.dart';
import 'package:jagomart/models/lokasi.dart';
import 'package:jagomart/models/nearby.dart';
import 'package:jagomart/viewmodels/lokasi/lokasi_model.dart';

enum LoadingStatusCabang {
  completed,
  searching,
  empty,
}

class LokasiListViewModel extends ChangeNotifier {
  LoadingStatusCabang loadingStatus = LoadingStatusCabang.searching;

  List<LokasiViewModel> lokasi = [];
  String _distance = "0 Meter";
  String get distance => _distance;
  int nearby = 0;
  List<NearbyModel> _nearbyModel = [];

  Future<int> getlokasi() async {
    this.loadingStatus = LoadingStatusCabang.searching;
    List<LokasiModel> newlokasi = await Webservice().getLokasi();

    this.lokasi = newlokasi.map((e) => LokasiViewModel(lokasi: e)).toList();

    if (this.lokasi.isEmpty) {
      this.loadingStatus = LoadingStatusCabang.empty;
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      Config.mylocation = LatLng(position.latitude, position.longitude);
      await getDistance(LatLng(position.latitude, position.longitude));
      this.loadingStatus = LoadingStatusCabang.completed;
    }

    notifyListeners();
    return nearby;
  }

  Future<void> getDistance(LatLng myLocation) async {
    for (int i = 0; i < lokasi.length; i++) {
      _distance = await CalculateDistance()
          .calculateDistanceCabang(myLocation, lokasi[i].location);
      await addToNearby(<NearbyModel>[
        NearbyModel(
            id: lokasi[i].id,
            title: lokasi[i].title,
            distance: int.parse(_distance),
            location: lokasi[i].location,
            phone: lokasi[i].phone)
      ]);
    }
    notifyListeners();
  }

  Future<void> addToNearby(nearby) async {
    _nearbyModel.clear();
    _nearbyModel.addAll(nearby);
    await nearBy(_nearbyModel);
    notifyListeners();
  }

  Future<void> nearBy(List<NearbyModel> listModel) async {
    if (listModel != null && listModel.isNotEmpty) {
      nearby = listModel.map<int>((e) => e.distance).reduce(min);
      final suggest = listModel
          .where((e) => e.distance
              .toString()
              .toLowerCase()
              .contains(nearby.toString().toLowerCase()))
          .toList();
      Config.nearby = suggest[0].id;
      Config.cabang = suggest[0].location;
      Config.lokasicabang = suggest[0].title;
      Config.phonecabang = suggest[0].phone;
    }
    notifyListeners();
  }
}
