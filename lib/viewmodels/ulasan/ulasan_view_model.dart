import 'dart:async';
import 'package:jagomart/config/web_service.dart';
import 'package:jagomart/models/models.dart';
import 'package:jagomart/viewmodels/ulasan/ulasan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UlasanBloc {
  List<UlasanViewModel> items = [];
  final StreamController<List<UlasanViewModel>> _itemsController =
      StreamController<List<UlasanViewModel>>();
  Stream<List<UlasanViewModel>> get ulasanStream => _itemsController.stream;

  void dispose() async {
    await ulasanStream.drain();
    _itemsController.close();
  }

  Future<void> getUlasan(String item) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      List<UlasanItemModel> newulasan =
          await Webservice().getUlasan(token, item);
      this.items = newulasan.map((e) => UlasanViewModel(items: e)).toList();
      _itemsController.sink.add(this.items);
    } catch (e) {
      _itemsController.sink.addError(e);
    }
  }
}
