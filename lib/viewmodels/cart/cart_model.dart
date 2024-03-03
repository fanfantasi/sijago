import 'package:jagomart/database/itemsmodel.dart';

class CartViewModel {
  CartItem _cart;
  CartViewModel({CartItem cart}) : _cart = cart;

  int get id {
    return _cart.id;
  }

  String get item {
    return _cart.item;
  }

  String get unit {
    return _cart.unit;
  }

  int get price {
    return _cart.price;
  }

  int get disc {
    return _cart.disc;
  }

  int get qty {
    return _cart.qty;
  }

  int get pricedisc {
    return _cart.pricedisc;
  }

  String get image {
    return _cart.image;
  }

  String get lokasi {
    return _cart.lokasi;
  }
}
