import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagomart/config/koneksi.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController _mapController;
  BitmapDescriptor customIcon;

  final Set<Marker> _markers = {};

  LatLng _initialPosition;
  String latlng;
  String address;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    _initialPosition =
        LatLng(Config.mylocation.latitude, Config.mylocation.longitude);
    final CameraPosition _kGooglePlex = CameraPosition(
      target: _initialPosition,
      zoom: 14.4746,
    );
    _updatePosition(_kGooglePlex);
    await getIcons();
  }

  void _updatePosition(CameraPosition _position) async {
    Marker marker = _markers.firstWhere(
        (p) => p.markerId == MarkerId('marker_2'),
        orElse: () => null);

    _markers.remove(marker);
    _markers.add(
      Marker(
        markerId: MarkerId('marker_2'),
        position: LatLng(_position.target.latitude, _position.target.longitude),
        draggable: true,
        infoWindow: InfoWindow(title: 'Lokasi Pengiriman', snippet: '$address'),
        icon: customIcon,
      ),
    );
    await getIcons();
    setState(() {
      _initialPosition =
          LatLng(_position.target.latitude, _position.target.longitude);
    });
  }

  Future<void> getIcons() async {
    var customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.4), "images/location.png");
    setState(() {
      this.customIcon = customIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.clear,
              size: 22.0,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: AutoSizeText(
            'Map Lokasi Pengiriman',
            maxFontSize: 16,
            minFontSize: 12,
            style: TextStyle(color: Colors.black87, fontSize: 16),
            textAlign: TextAlign.left,
          ),
          elevation: 0.0,
          actions: [
            FlatButton(
              onPressed: () async {
                Config.mylocation = LatLng(
                    _initialPosition.latitude, _initialPosition.longitude);
                final imageBytes = await _mapController?.takeSnapshot();
                Navigator.of(context).pop([imageBytes, _initialPosition]);
              },
              child: AutoSizeText(
                'Selesai',
                maxFontSize: 16,
                minFontSize: 12,
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
            )
          ],
        ),
        body: Stack(children: <Widget>[
          _initialPosition == null
              ? Container(
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        padding: EdgeInsets.all(12.0),
                        child: LoadingIndicator(
                            color: jagoRed,
                            indicatorType: Indicator.circleStrokeSpin),
                      ),
                      Text(
                        'Loading Maps',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  )),
                )
              : Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: GoogleMap(
                      markers: _markers,
                      mapToolbarEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 15.4746,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                        setState(() {
                          _markers.add(Marker(
                              markerId: MarkerId('marker_2'),
                              position: _initialPosition,
                              icon: customIcon));
                        });
                      },
                      onCameraMove: ((_position) => _updatePosition(_position)),
                    ),
                  ),
                ),
        ]));
  }
}
