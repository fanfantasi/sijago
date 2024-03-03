import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/models/models.dart';

class MitraViewModel {
  MitraModel _mitra;
  MitraViewModel({MitraModel mitra}) : _mitra = mitra;

  String get id {
    return _mitra.id;
  }

  String get title {
    return _mitra.title;
  }

  LatLng get location {
    return _mitra.location;
  }

  String get jam {
    return _mitra.jam;
  }

  String get operasional {
    return _mitra.operasional;
  }

  String get image {
    return _mitra.image;
  }

  bool get status {
    return _mitra.status;
  }

  String get distance {
    return _mitra.distance;
  }
}
