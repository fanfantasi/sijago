import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyModel {
  String id;
  String title;
  int distance;
  LatLng location;
  String phone;

  NearbyModel({this.id, this.title, this.distance, this.location, this.phone});

  Map<String, dynamic> toMap() =>
      {"id": id, "title": title, "distance": distance, 'phone': phone};
}
