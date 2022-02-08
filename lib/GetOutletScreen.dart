import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map/map.dart';

import 'RedMapScreen.dart';
import 'backend/Outlet.dart';
import 'backend/OutletService.dart';
import 'package:latlng/latlng.dart';

class GetOutletScreen extends StatelessWidget {
  final double redRadius;
  final LatLng latLng;

  GetOutletScreen(this.redRadius, this.latLng);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GeolocatorPlatform.instance
          .getCurrentPosition()
          .then((value) async {
        List<Outlet> outlets = await OutletService()
            .getNearbyOutlets(redRadius, latLng.latitude, latLng.longitude);
        return [outlets, value];
      }),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Outlet> outletLatLng = snapshot.data[0];
          Position position = snapshot.data[1];
          final controller = MapController(
            location: LatLng(position.latitude, position.longitude),
          );
          return RedMapScreen(outletLatLng, redRadius,
              controller, LatLng(position.latitude, position.longitude));
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
