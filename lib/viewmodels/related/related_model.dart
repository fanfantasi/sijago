import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/models/models.dart';

class RelatedViewModel {
  RelatedModel _items;
  RelatedViewModel({RelatedModel items}) : _items = items;

  String get id {
    return _items.id;
  }

  String get item {
    return _items.item;
  }

  String get kategori {
    return _items.kategori;
  }

  String get group {
    return _items.group;
  }

  int get stock {
    return _items.stock;
  }

  String get unit {
    return _items.unit;
  }

  int get price {
    return _items.price;
  }

  int get disc {
    return _items.disc;
  }

  int get pricedisc {
    return _items.pricedisc;
  }

  String get tags {
    return _items.tags;
  }

  String get desc {
    return _items.desc;
  }

  String get mitraid {
    return _items.mitraid;
  }

  String get mitra {
    return _items.mitra;
  }

  String get mitraimage {
    return _items.mitraimage;
  }

  LatLng get location {
    return _items.location;
  }

  String get jamoperasional {
    return _items.jamoperasional;
  }

  String get operasional {
    return _items.operasional;
  }

  bool get operasionalstatus {
    return _items.operasionalstatus;
  }

  int get sould {
    return _items.sould;
  }

  List get images {
    return _items.images;
  }

  List get rating {
    return _items.rating;
  }

  String get distance {
    return _items.distance;
  }
}
