import 'package:jagomart/models/models.dart';

class OrderViewModel {
  OrdersModel _order;
  OrderViewModel({OrdersModel order}) : _order = order;

  String get id {
    return _order.id;
  }

  String get transid {
    return _order.transid;
  }

  int get driverid {
    return _order.driverid;
  }

  int get deliverid {
    return _order.deliverid;
  }

  String get datetrans {
    return _order.datetrans;
  }

  int get qty {
    return _order.qty;
  }

  int get totalprice {
    return _order.totalprice;
  }

  int get ongkir {
    return _order.ongkir;
  }

  String get remarks {
    return _order.remarks;
  }

  int get status {
    return _order.status;
  }

  int get transstatus {
    return _order.transstatus;
  }

  int get statusdone {
    return _order.statusdone;
  }

  int get payid {
    return _order.payid;
  }

  String get payment {
    return _order.payment;
  }

  String get icon {
    return _order.icon;
  }

  int get paystatus {
    return _order.paystatus;
  }

  int get methodstatus {
    return _order.methodstatus;
  }

  String get rekening {
    return _order.rekening;
  }

  int get paysaldo {
    return _order.paysaldo;
  }

  int get cabang {
    return _order.cabang;
  }

  int get review {
    return _order.review;
  }

  List get items {
    return _order.items;
  }
}
