import 'package:google_maps_flutter/google_maps_flutter.dart';

class MitraModel {
  String id;
  String title;
  String jam;
  LatLng location;
  String operasional;
  String image;
  bool status;
  String distance;

  MitraModel(
      {this.id,
      this.title,
      this.jam,
      this.location,
      this.operasional,
      this.image,
      this.status,
      this.distance});
  MitraModel.fromJson(Map json) {
    String str = json['location'];
    var arrlocation = str.split(',');
    id = json['id'];
    title = json['title'];
    location =
        LatLng(double.parse(arrlocation[0]), double.parse(arrlocation[1]));
    jam = json['jam_operasional'];
    operasional = json['operasional'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['title'] = this.title;
    data['jam_operasional'] = this.jam;
    data['location'] = this.location;
    data['operasional'] = this.operasional;
    data['image'] = this.image;
    data['status'] = this.status;
    return data;
  }
}
