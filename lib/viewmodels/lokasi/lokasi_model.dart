import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/models/lokasi.dart';

class LokasiViewModel {
  LokasiModel _lokasi;
  LokasiViewModel({LokasiModel lokasi}) : _lokasi = lokasi;

  String get id {
    return _lokasi.id;
  }

  String get title {
    return _lokasi.title;
  }

  LatLng get location {
    return _lokasi.location;
  }

  String get phone {
    return _lokasi.phone;
  }
}
