import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {

    markers.addAll([
    Marker(
    markerId: MarkerId('value'),
    position: LatLng(-6.200000, 106.816666))
    ]);

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: const LatLng(-6.200000, 106.816666),
            zoom: 11.0,
          ),
          markers: markers,
        ),
      ),
    );
  }
}
