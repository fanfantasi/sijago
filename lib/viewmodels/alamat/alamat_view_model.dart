import 'dart:async';

import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/alamat/alamat_model.dart';
import 'package:jagomart/viewmodels/aksi/aksi_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlamatBloc {
  List<AlamatViewModel> alamat = [];
  List<AksiViewModel> aksi = [];

  final StreamController<List<AlamatViewModel>> _alamatController =
      StreamController<List<AlamatViewModel>>();
  Stream<List<AlamatViewModel>> get alamatStream => _alamatController.stream;

  void dispose() async {
    await alamatStream.drain();
    _alamatController.close();
  }

  Future<void> getalamat() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<AlamatModel> newalamat = await Webservice().getAlamat(token);
      this.alamat = newalamat.map((e) => AlamatViewModel(alamat: e)).toList();
      _alamatController.sink.add(this.alamat);
    } catch (e) {
      _alamatController.sink.addError(e);
    }
  }

  Future<void> deletedalamat(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    AksiModel aksi = await Webservice().removeAlamat(token, id);
    prefs.remove('alamat');
    prefs.remove('imgmap');
    prefs.remove('deliverid');
    prefs.remove('latitude');
    prefs.remove('longitude');
    return aksi;
  }

  Future<void> addalamat(fullname, phone, address, location, map) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    AksiModel aksi = await Webservice()
        .addAlamat(token, fullname, phone, address, location, map);
    return aksi;
  }
}
