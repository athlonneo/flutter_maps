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
                  markers: createMarkers(),
                );
              } else {
                return Text("Loading...");
              }
            }),
      ),
    );
  }

  Set<Marker> createMarkers() {
    Set<Marker> markers = {};
    for(int i = 0; i < 4; i++){
      markers.add(Marker(
        markerId: MarkerId(countriesData[i][3].substring(2,countriesData[i][3].length-2)),
        position: LatLng(countriesData[i][1], countriesData[i][2]),
        infoWindow: InfoWindow(title: countriesData[i][3].substring(2,countriesData[i][3].length-2) , snippet: 'c'+countriesData[i][5].toString()+', r'+countriesData[i][6].toString()+', d'+countriesData[i][7].toString()),
      ));
    }
    //print(countriesData.toString());
    return markers;
  }
}


Future<List> loadAsset() async {
  List<List<dynamic>> countriesData = [];
  final data = await rootBundle.loadString("assets/countries.csv");
  countriesData = CsvToListConverter().convert(data);

  for (var i = 0; i < 4; i++) {
    final response = await http.get('https://covid19.mathdro.id/api/countries/'+countriesData[i][0].substring(2,4));
    Map<String, dynamic> covidData = json.decode(response.body);
    countriesData[i].add(covidData['confirmed']['value']);
    countriesData[i].add(covidData['recovered']['value']);
    countriesData[i].add(covidData['deaths']['value']);
    print(countriesData[i]);
  }
  return countriesData;
}
