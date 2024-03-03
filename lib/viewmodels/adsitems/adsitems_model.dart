import 'package:jagomart/models/adsitems.dart';

class AdsItemsViewModel {
  AdsItemsModel _ads;
  AdsItemsViewModel({AdsItemsModel ads}) : _ads = ads;

  String get id {
    return _ads.id;
  }

  String get title {
    return _ads.title;
  }

  String get fasilitas {
    return _ads.fasilitas;
  }

  String get image {
    return _ads.image;
  }

  String get desc {
    return _ads.desc;
  }

  String get jenis {
    return _ads.jenis;
  }

  String get stock {
    return _ads.stock;
  }

  int get price {
    return _ads.price;
  }
}
