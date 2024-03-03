import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/models/models.dart';

class PromoViewModel {
  PromoModel _promo;
  PromoViewModel({PromoModel promo}) : _promo = promo;

  String get id {
    return _promo.id;
  }

  String get item {
    return _promo.item;
  }

  String get kategori {
    return _promo.kategori;
  }

  String get group {
    return _promo.group;
  }

  String get unit {
    return _promo.unit;
  }

  int get stock {
    return _promo.stock;
  }

  int get price {
    return _promo.price;
  }

  int get disc {
    return _promo.disc;
  }

  int get pricedisc {
    return _promo.pricedisc;
  }

  String get tags {
    return _promo.tags;
  }

  String get desc {
    return _promo.desc;
  }

  String get mitraid {
    return _promo.mitraid;
  }

  String get mitra {
    return _promo.mitra;
  }

  String get mitraimage {
    return _promo.mitraimage;
  }

  LatLng get location {
    return _promo.location;
  }

  String get jamoperasional {
    return _promo.jamoperasional;
  }

  String get operasional {
    return _promo.operasional;
  }

  bool get operasionalstatus {
    return _promo.operasionalstatus;
  }

  int get sould {
    return _promo.sould;
  }

  List get images {
    return _promo.images;
  }

  List get rating {
    return _promo.rating;
  }

  String get distance {
    return _promo.distance;
  }
}
