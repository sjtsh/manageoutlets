import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:manage_outlets/SplashScreen.dart';
import 'package:manage_outlets/backend/Entities/Distributor.dart';
import 'package:manage_outlets/backend/Services/CategoryService.dart';
import 'package:manage_outlets/backend/Services/DistributorService.dart';
import 'package:map/map.dart';

import 'RedMapScreen.dart';
import 'backend/Entities/Category.dart';
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
        List<Outlet> outlets = await OutletService().getNearbyOutlets(context);
        List<Distributor> distributors =
            await DistributorService().getDistributor();
            print(distributors);
        List<Category> categories = await CategoryService().getCatagory();
        return [outlets, distributors, categories, value];
      }),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Outlet> outletLatLng = snapshot.data[0];
          List<Distributor> distributors = snapshot.data[1];
          List<Category> categories = snapshot.data[2];
          Position position = snapshot.data[3];
          final controller = MapController(
            location: LatLng(position.latitude, position.longitude),
            zoom: 17,
          );
          return RedMapScreen(
              outletLatLng,
              redRadius,
              controller,
              LatLng(position.latitude, position.longitude),
              distributors,
              categories);
        }
        return const SplashScreen();
      },
    );
  }
}
