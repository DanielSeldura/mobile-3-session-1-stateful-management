import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:state_change_demo/src/dialogs/waiting_dialog.dart';

String googleApiKey =
    const String.fromEnvironment("GOOGLE_API", defaultValue: '');

class GoogleMapDemoScreen extends StatefulWidget {
  static const String route = "/map";
  static const String name = "Map";

  const GoogleMapDemoScreen({super.key});

  @override
  State<GoogleMapDemoScreen> createState() => _GoogleMapDemoScreenState();
}

class _GoogleMapDemoScreenState extends State<GoogleMapDemoScreen> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  GoogleMapController? mapController;
  String? googleMapStyleString;
  // loadMapString() async {
  //   String style =
  //       await DefaultAssetBundle.of(context).loadString('assets/map.json');
  //   print(style);
  //   setState(() {
  //     googleMapStyleString = style;
  //   });
  //   mapController?.getStyleError().then(print);
  // }

  Set<Marker> pinMarkers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Google Maps Demo"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.pin_drop),
        onPressed: () async {
          if (mapController != null) {
            LatLngBounds? bounds = await mapController?.getVisibleRegion();
            if (bounds == null) return;
            LatLng center = getCenterPoint(bounds.southwest, bounds.northeast);
            print("Center LatLng: ${center.latitude}, ${center.longitude}");

            pinMarkers.add(
              Marker(
                  draggable: true,
                  markerId: MarkerId(
                      DateTime.now().millisecondsSinceEpoch.toString()),
                  position: center),
            );
            setState(() {});
          }
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              style: googleMapStyleString,
              markers: pinMarkers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                setState(() {
                  mapController = controller;
                });
                // loadMapString();
              },
            ),
            if (mapController == null) const WaitingDialog()
          ],
        ),
      ),
    );
  }

  LatLng getCenterPoint(LatLng southwest, LatLng northeast) {
    double centerLat = (southwest.latitude + northeast.latitude) / 2;
    double centerLng = (southwest.longitude + northeast.longitude) / 2;
    return LatLng(centerLat, centerLng);
  }
}
