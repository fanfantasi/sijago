import 'package:jagomart/models/models.dart';

class UlasanViewModel {
  UlasanItemModel _items;
  UlasanViewModel({UlasanItemModel items}) : _items = items;

  String get id {
    return _items.id;
  }

  String get customer {
    return _items.customer;
  }

  String get avatar {
    return _items.avatar;
  }

  int get rating {
    return _items.rating;
  }

  String get remarks {
    return _items.remarks;
  }

  String get date {
    return _items.date;
  }
}
