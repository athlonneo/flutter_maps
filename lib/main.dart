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
  List<List<dynamic>> countriesData = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps'),
          centerTitle: true,
        ),
        body: FutureBuilder<List>(
            future: loadAsset(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                countriesData = snapshot.data;
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: const LatLng(-0.789275, 113.921327),
                    zoom: 1.0,
                  ),
                  onCameraMove: _onCameraMove,
                  markers: createMarkers(),
                );
              } else {
                return Text("Failed Loading");
              }
            }),
      ),
    );
  }

  Set<Marker> createMarkers() {
    Set<Marker> markers = {};
    for(int i = 0; i < 244; i++){
      markers.add(Marker(
        markerId: MarkerId(countriesData[i][3].substring(2,countriesData[i][3].length-2)),
        position: LatLng(countriesData[i][1], countriesData[i][2]),
        infoWindow: InfoWindow(title: countriesData[i][3].substring(2,countriesData[i][3].length-2) , snippet: countriesData[i][3].substring(2,countriesData[i][3].length-2)),
      ));
    }
    print(countriesData.toString());
    return markers;
  }

  _onCameraMove(CameraPosition position){
    print('move');
    print(countriesData[1][3].substring(2,countriesData[1][3].length-2));
    // print(countriesData.length.t);
  }

}


Future<List> loadAsset() async {
  List<List<dynamic>> countriesData = [];
  final data = await rootBundle.loadString("assets/countries.csv");
  countriesData = CsvToListConverter().convert(data);
  return countriesData;
}

Future<CovidData> fetchData() async {
  final response =
      await http.get('https://covid19.mathdro.id/api/countries/indonesia');

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
