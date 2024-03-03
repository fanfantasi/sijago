import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdsModel {
  String id;
  String title;
  String image;
  String jenis;
  String link;
  LatLng location;
  String distance;
  String phone;
  int posisi;

  AdsModel(
      {this.id,
      this.title,
      this.image,
      this.location,
      this.jenis,
      this.link,
      this.distance,
      this.phone,
      this.posisi});
  AdsModel.fromJson(Map json) {
    String str = json['lokasi'];
    var arrlocation = str.split(',');
    id = json['id'];
    title = json['title'];
    location =
        LatLng(double.parse(arrlocation[0]), double.parse(arrlocation[1]));
    jenis = json['jenis'];
    link = json['link'];
    image = json['image'];
    phone = json['phone'];
    posisi = json['posisi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['id'] = this.id;
    data['title'] = this.title;
    data['jenis'] = this.jenis;
    data['location'] = this.location;
    data['link'] = this.link;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['posisi'] = this.posisi;
    return data;
  }
}
