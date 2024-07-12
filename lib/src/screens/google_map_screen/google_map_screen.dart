import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:state_change_demo/src/controllers/location_controller.dart';
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

  bool canGetPosition = false;

  GoogleMapController? mapController;
  String? googleMapStyleString;

  Map<String, Marker> markersMap = {};

  Set<Marker> pinMarkers = {};

  late LocationController locationController;

  @override
  void initState() {
    super.initState();
    locationController = LocationController();
    locationController.initializePermissions().then((v) {
      print(v);
      setState(() {
        canGetPosition = v;
      });
      locationController.getMyCurrentLocationAndListen().then((position) {
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 16.23),
          ),
        );
      });
      locationController.currentPosition.addListener(updateCameraAndMarker);
    });
  }

  bool followLocationMovements = false;

  updateCameraAndMarker() {
    print("current position has been updated");
    if (followLocationMovements) {
      LatLng me = LatLng(locationController.currentPosition.value.latitude,
          locationController.currentPosition.value.longitude);
      markersMap['me'] =
          Marker(draggable: true, markerId: const MarkerId("me"), position: me);
      setState(() {
        pinMarkers = Set.from(markersMap.values);
      });
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: me, zoom: 16.23),
        ),
      );
    }
  }

  handleFollowToggle(bool followEnabled) {
    setState(() {
      followLocationMovements = followEnabled;
    });
  }

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

            String unique = DateTime.now().millisecondsSinceEpoch.toString();
            markersMap[unique] = Marker(
                draggable: true, markerId: MarkerId(unique), position: center);

            setState(() {
              pinMarkers = Set.from(markersMap.values);
            });
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: 52,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Enable follow"),
                    Switch(
                        value: followLocationMovements,
                        onChanged: handleFollowToggle)
                  ]),
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: locationController.currentPosition,
                  builder: (context, position, _) {
                    return Stack(
                      children: [
                        GoogleMap(
                          myLocationButtonEnabled: false,
                          myLocationEnabled: false,
                          mapType: MapType.hybrid,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                locationController
                                    .currentPosition.value.latitude,
                                locationController
                                    .currentPosition.value.longitude),
                            zoom: 10,
                          ),
                          style: googleMapStyleString,
                          markers: pinMarkers,
                          onMapCreated: (GoogleMapController controller) {
                            setState(() {
                              mapController = controller;
                            });
                            // loadMapString();
                          },
                        ),
                        if (mapController == null) const WaitingDialog()
                      ],
                    );
                  }),
            ),
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
