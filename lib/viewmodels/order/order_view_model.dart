import 'dart:async';

import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/aksi/aksi_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:jagomart/viewmodels/order/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderBloc {
  List<OrderViewModel> history = [];
  List<OrdersModel> orderdetail = [];
  List<AksiViewModel> aksi = [];
  final StreamController<List<OrderViewModel>> _historyController =
      StreamController<List<OrderViewModel>>();
  Stream<List<OrderViewModel>> get historyStream => _historyController.stream;

  final PublishSubject _isInvoice = PublishSubject<List<OrderViewModel>>();
  Stream<List<OrderViewModel>> get isInvoice => _isInvoice.stream;

  final PublishSubject _isReview = PublishSubject<List<AksiModel>>();

  Stream<List<AksiModel>> get isReview => _isReview.stream;

  void dispose() async {
    await historyStream.drain();
    _historyController.close();

    await isReview.drain();
    _isReview.close();

    await isInvoice.drain();
    _isInvoice.close();
  }

  Future<bool> getHistorytop(int start) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      this.history.clear();
      List<OrdersModel> newhistory = await Webservice().getorder(token, start);
      this.history = newhistory.map((e) => OrderViewModel(order: e)).toList();
      _historyController.sink.add(this.history);
      return false;
    } catch (e) {
      _historyController.sink.addError(e);
      return false;
    }
  }

  Future<bool> getHistory(int start) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<OrdersModel> newhistory = await Webservice().getorder(token, start);
      var history = newhistory.map((e) => OrderViewModel(order: e)).toList();
      this.history.addAll(history);
      if (history.isEmpty) {
        return false;
      } else {
        _historyController.sink.add(this.history);
        return true;
      }
    } catch (e) {
      _historyController.sink.addError(e);
    }
    return null;
  }

  Future<void> getorderbyid(transid) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      this.orderdetail.clear();
      List<OrdersModel> _history =
          await Webservice().getorderbyid(token, transid);
      this.history = _history.map((e) => OrderViewModel(order: e)).toList();
      this.orderdetail = _history;
      _isInvoice.sink.add(this.history);
    } catch (e) {
      _isInvoice.sink.addError(e);
    }
  }

  Future<void> confirmorder(id, ongkir, driverid) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<AksiModel> newAksi =
          await Webservice().confirmOrder(token, id, ongkir, driverid);
      this.aksi = newAksi.map((e) => AksiViewModel(aksi: e)).toList();
      _isReview.sink.add(this.aksi);
    } catch (e) {
      _isReview.sink.addError(e);
    }
  }

  Future<void> insertReview(id, rating, remarks, data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<AksiModel> newAksi =
          await Webservice().insertReview(token, id, rating, remarks, data);
      this.aksi = newAksi.map((e) => AksiViewModel(aksi: e)).toList();
      _isReview.sink.add(this.aksi);
    } catch (e) {
      _isReview.sink.addError(e);
    }
  }
}
