import 'package:flutter/widgets.dart';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/saldo/saldo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoadingStatusSaldo {
  completed,
  searching,
  empty,
}

class SaldoListViewModel extends ChangeNotifier {
  LoadingStatusSaldo loadingStatus = LoadingStatusSaldo.searching;

  List<SaldoViewModel> saldo = [];

  Future<void> getsaldo() async {
    saldo.clear();
    this.loadingStatus = LoadingStatusSaldo.searching;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<SaldoModel> newsaldo = await Webservice().getSaldo(token);

      this.saldo = newsaldo.map((e) => SaldoViewModel(saldo: e)).toList();

      if (this.saldo.isEmpty) {
        this.loadingStatus = LoadingStatusSaldo.empty;
      } else {
        this.loadingStatus = LoadingStatusSaldo.completed;
      }
    } catch (e) {
      this.loadingStatus = LoadingStatusSaldo.empty;
    }

    notifyListeners();
  }

  bool _cheksaldo = false;
  bool get checksaldo => _cheksaldo;

  void getCheckSaldo(bool isCheck, int saldo) async {
    _cheksaldo = isCheck;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('statusPayment') == 1) {
      if (saldo < 1000) {
        _cheksaldo = false;
      } else {
        _cheksaldo = true;
      }
    } else {
      _cheksaldo = false;
    }

    notifyListeners();
  }
}
