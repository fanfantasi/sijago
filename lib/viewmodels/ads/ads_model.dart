import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/models/models.dart';

class AdsViewModel {
  AdsModel _ads;
  AdsViewModel({AdsModel ads}) : _ads = ads;

  String get id {
    return _ads.id;
  }

  String get title {
    return _ads.title;
  }

  LatLng get location {
    return _ads.location;
  }

  String get jenis {
    return _ads.jenis;
  }

  String get link {
    return _ads.link;
  }

  String get image {
    return _ads.image;
  }

  String get distance {
    return _ads.distance;
  }

  String get phone {
    return _ads.phone;
  }

  int get posisi {
    return _ads.posisi;
  }
}
