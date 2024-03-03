import 'dart:async';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/tracking/traking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackingBloc {
  List<TrackingViewModel> tracking = [];
  final StreamController<List<TrackingViewModel>> _trackingController =
      StreamController<List<TrackingViewModel>>();
  Stream<List<TrackingViewModel>> get trackingStream =>
      _trackingController.stream;

  void dispose() async {
    await trackingStream.drain();
    _trackingController.close();
  }

  Future<void> getTracking(transid) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<TrackingModel> newtracking =
          await Webservice().getTracking(token, transid);
      this.tracking =
          newtracking.map((e) => TrackingViewModel(tracking: e)).toList();
      _trackingController.sink.add(this.tracking);
    } catch (e) {
      _trackingController.sink.addError(e);
    }
  }
}
