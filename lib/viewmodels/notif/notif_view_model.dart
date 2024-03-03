import 'dart:async';

import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/notif/notif_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifBloc {
  List<NotifViewModel> notif = [];
  final StreamController<List<NotifViewModel>> _notifController =
      StreamController<List<NotifViewModel>>();
  Stream<List<NotifViewModel>> get notifStream => _notifController.stream;

  void dispose() async {
    await notifStream.drain();
    _notifController.close();
  }

  Future<bool> getNotifTop(int start) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      this.notif.clear();
      List<NotifModel> newnotif = await Webservice().getNotif(token, start);
      this.notif = newnotif.map((e) => NotifViewModel(notif: e)).toList();
      _notifController.sink.add(this.notif);
      return false;
    } catch (e) {
      _notifController.sink.addError(e);
      return false;
    }
  }

  Future<bool> getNotif(int start) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<NotifModel> newnotif = await Webservice().getNotif(token, start);
      var notif = newnotif.map((e) => NotifViewModel(notif: e)).toList();
      this.notif.addAll(notif);
      if (notif.isEmpty) {
        return false;
      } else {
        _notifController.sink.add(this.notif);
        return true;
      }
    } catch (e) {
      _notifController.sink.addError(e);
    }
    return null;
  }
}
