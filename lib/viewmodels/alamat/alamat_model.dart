import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/models/models.dart';

class AlamatViewModel {
  AlamatModel _alamat;
  AlamatViewModel({AlamatModel alamat}) : _alamat = alamat;

  String get id {
    return _alamat.id;
  }

  String get fullname {
    return _alamat.fullname;
  }

  String get phone {
    return _alamat.phone;
  }

  String get address {
    return _alamat.address;
  }

  String get map {
    return _alamat.map;
  }

  LatLng get location {
    return _alamat.location;
  }
}
