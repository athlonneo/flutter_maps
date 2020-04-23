import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  Completer<GoogleMapController> _controller = Completer();
  List<List<dynamic>> countriesData = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps'),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
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
      markerId: MarkerId('Indonesia'),
      position: LatLng(-0.789275, 113.921327),
      infoWindow: InfoWindow(title: 'Indonesia', snippet: countriesData.toString()),
    ));

    return markers;
  }

  loadAsset() async{
    final data = await rootBundle.loadString("assets/countries.csv");
    countriesData = CsvToListConverter().convert(data);
  }

  _onMapCreated(GoogleMapController controller) {
    loadAsset();
    _controller.complete(controller);
  }
}

Future<CovidData> fetchData() async {
  final response = await http.get('https://covid19.mathdro.id/api/countries/indonesia');

  if (response.statusCode == 200) {
    return CovidData.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

class CovidData {
  int confirmed;
  int recovered;
  int death;

  CovidData({this.confirmed, this.recovered, this.death});

  factory CovidData.fromJson(Map<String, dynamic> json) {
    return CovidData(
      confirmed: json['confirmed']['value'],
      recovered: json['recovered']['value'],
      death: json['death']['value'],
    );
  }
}

