import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:manage_outlets/backend/OutletService.dart';
import 'package:map/map.dart';

import 'package:latlng/latlng.dart';
import 'RedMapScreen.dart';
import 'backend/Outlet.dart';
import 'mapscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double redRadius = 10000;

  setRedRadius(double newRadius) {
    setState(() {
      redRadius = newRadius;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Map Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: FutureBuilder(
        future: GeolocatorPlatform.instance
            .getCurrentPosition()
            .then((value) async {
          List<Outlet> outlets = await OutletService()
              .getNearbyOutlets(redRadius, value.latitude, value.longitude);
          return [outlets, value];
        }),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Outlet> outletLatLng = snapshot.data[0];
            Position position = snapshot.data[1];
            final controller = MapController(
              location: LatLng(position.latitude, position.longitude),
            );
            return RedMapScreen(outletLatLng, redRadius, setRedRadius,
                controller, LatLng(position.latitude, position.longitude));
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
