import 'package:jagomart/models/models.dart';

class OngkirViewModel {
  OngkirModel _ongkir;
  OngkirViewModel({OngkirModel ongkir}) : _ongkir = ongkir;

  int get id {
    return _ongkir.id;
  }

  int get rates {
    return _ongkir.rates;
  }

  int get ratesmin {
    return _ongkir.ratesmin;
  }

  int get max {
    return _ongkir.max;
  }

  int get min {
    return _ongkir.min;
  }
}
