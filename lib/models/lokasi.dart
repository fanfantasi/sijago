import 'package:google_maps_flutter/google_maps_flutter.dart';

class LokasiModel {
  String id;
  String title;
  LatLng location;
  String phone;

  LokasiModel({this.id, this.title, this.location, this.phone});
  LokasiModel.fromJson(Map json) {
    String str = json['location'];
    var arrlocation = str.split(',');
    id = json['id'];
    title = json['title'];
    phone = json['phone'];
    location =
        LatLng(double.parse(arrlocation[0]), double.parse(arrlocation[1]));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['title'] = this.title;
    data['location'] = this.location;
    data['phone'] = this.phone;
    return data;
  }
}
