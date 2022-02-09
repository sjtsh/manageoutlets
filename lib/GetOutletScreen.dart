import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:manage_outlets/backend/Entities/Distributor.dart';
import 'package:manage_outlets/backend/Services/DistributorService.dart';
import 'package:map/map.dart';

import 'RedMapScreen.dart';
import 'backend/Entities/Outlet.dart';
import 'backend/Services/OutletService.dart';
import 'package:latlng/latlng.dart';

import 'backend/database.dart';

class GetOutletScreen extends StatelessWidget {
  final double redRadius;
  GetOutletScreen(this.redRadius);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          GeolocatorPlatform.instance.getCurrentPosition().then((value) async {
        List<Outlet> outlets = await OutletService()
            .getNearbyOutlets(redRadius, value.latitude, value.longitude);
        List<Distributor> distributors =
            await DistributorService().getDistributor();

        return [outlets, distributors, value];
      }),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Outlet> outletLatLng = snapshot.data[0];
          List<Distributor> distributors = snapshot.data[1];
          Position position = snapshot.data[2];
          final controller = MapController(
            location: LatLng(position.latitude, position.longitude),
            zoom: 17,
          );
          return RedMapScreen(outletLatLng, redRadius, controller,
              LatLng(position.latitude, position.longitude), distributors);
        }
        return  Scaffold(
          body: Center(
            child: Image.asset(logo1,width: 300, height: 320,)
          ),
        );
      },
    );
  }
}