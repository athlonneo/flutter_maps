import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps'),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: const LatLng(-0.789275, 113.921327),
            zoom: 1.0,
          ),
          markers: createMarkers(),
        ),
      ),
    );
  }

  Set<Marker> createMarkers() {
    Set<Marker> markers = {};

    markers.add(Marker(
      markerId: MarkerId('indonesia'),
      position: LatLng(-0.789275, 113.921327),
      infoWindow: InfoWindow(title: 'Indonesia', snippet: 'test'),
    ));

    return markers;
  }

}
