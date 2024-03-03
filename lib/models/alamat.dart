import 'package:google_maps_flutter/google_maps_flutter.dart';

class AlamatModel {
  String id;
  String fullname;
  String phone;
  String address;
  LatLng location;
  String map;

  AlamatModel(
      {this.id,
      this.fullname,
      this.phone,
      this.address,
      this.location,
      this.map});
  AlamatModel.fromJson(Map json) {
    String str = json['location'];
    var arrlocation = str.split(',');
    id = json['_id'];
    fullname = json['full_name'];
    phone = json['phone'];
    address = json['address'];
    location =
        LatLng(double.parse(arrlocation[0]), double.parse(arrlocation[1]));
    map = json['map'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['_id'] = this.id;
    data['full_name'] = this.fullname;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['location'] = this.location;
    data['map'] = this.map;
    return data;
  }
}
