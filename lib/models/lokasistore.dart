import 'package:google_maps_flutter/google_maps_flutter.dart';

class LokasiStore {
  int itemid;
  LatLng lokasi;

  LokasiStore({
    this.lokasi,
    this.itemid,
  });

  factory LokasiStore.fromMap(Map<String, dynamic> json) =>
      new LokasiStore(lokasi: json["lokasi"], itemid: json["itemid"]);

  Map<String, dynamic> toMap() => {"lokasi": lokasi, "itemid": itemid};
}

class LokasiStoreTerjauh {
  LatLng lokasi;
  double distance;

  LokasiStoreTerjauh({this.lokasi, this.distance});

  factory LokasiStoreTerjauh.fromMap(Map<String, dynamic> json) =>
      new LokasiStoreTerjauh(
          lokasi: json["lokasi"], distance: json['distance']);

  Map<String, dynamic> toMap() => {"lokasi": lokasi, "distance": distance};
}
