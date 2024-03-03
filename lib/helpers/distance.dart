import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CalculateDistance {
  /// Calculate distance between two location
  Future<String> calculateDistance(LatLng firstLocation, LatLng secondLocation) async {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((secondLocation.latitude - firstLocation.latitude) * p)/2 + 
          c(firstLocation.latitude * p) * c(secondLocation.latitude * p) * 
          (1 - c((secondLocation.longitude - firstLocation.longitude) * p))/2;
    var distance = 12742 * asin(sqrt(a));
    
    return double.parse(distance.toStringAsFixed(3)).toString();

  }

  /// Calculate distance between two location
  Future<String> calculateDistanceCabang(LatLng firstLocation, LatLng secondLocation) async {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((secondLocation.latitude - firstLocation.latitude) * p)/2 + 
          c(firstLocation.latitude * p) * c(secondLocation.latitude * p) * 
          (1 - c((secondLocation.longitude - firstLocation.longitude) * p))/2;
    var distance = 12742 * asin(sqrt(a));

    return (double.parse(distance.toStringAsFixed(3)) * 1000).toString().split(".")[0];
  }

}