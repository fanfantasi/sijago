import 'package:jagomart/models/models.dart';

class PaymentViewModel {
  PaymentModel _payment;
  PaymentViewModel({PaymentModel payment}) : _payment = payment;

  int get id {
    return _payment.id;
  }

  String get payment {
    return _payment.payment;
  }

  String get rekening {
    return _payment.rekening;
  }

  int get status {
    return _payment.status;
  }

  String get icon {
    return _payment.icon;
  }
}
