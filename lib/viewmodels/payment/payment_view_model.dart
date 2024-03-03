import 'dart:async';

import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/payment/payment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentBloc {
  List<PaymentViewModel> payment = [];
  final StreamController<List<PaymentViewModel>> _paymentController =
      StreamController<List<PaymentViewModel>>();
  Stream<List<PaymentViewModel>> get paymentStream => _paymentController.stream;

  void dispose() async {
    await paymentStream.drain();
    _paymentController.close();
  }

  Future<void> getpayment() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<PaymentModel> newalamat = await Webservice().getPayment(token);
      this.payment =
          newalamat.map((e) => PaymentViewModel(payment: e)).toList();
      _paymentController.sink.add(this.payment);
    } catch (e) {
      _paymentController.sink.addError(e);
    }
  }
}
