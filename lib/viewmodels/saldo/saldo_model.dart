import 'package:jagomart/models/models.dart';

class SaldoViewModel {
  SaldoModel _saldo;
  SaldoViewModel({SaldoModel saldo}) : _saldo = saldo;

  int get saldo {
    return _saldo.saldo;
  }
}
