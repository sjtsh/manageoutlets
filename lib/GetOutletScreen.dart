import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:manage_outlets/SplashScreen.dart';
import 'package:manage_outlets/backend/Entities/Distributor.dart';
import 'package:manage_outlets/backend/Services/CategoryService.dart';
import 'package:manage_outlets/backend/Services/DistributorService.dart';
import 'package:map/map.dart' as mp;

import 'RedMapScreen.dart';
import 'backend/Entities/Category.dart';
import 'backend/Entities/Outlet.dart';
import 'backend/Services/OutletService.dart';
import 'package:latlng/latlng.dart';

import 'backend/database.dart';

class GetOutletScreen extends StatefulWidget {
  final double redRadius;

  GetOutletScreen(this.redRadius);

  @override
  State<GetOutletScreen> createState() => _GetOutletScreenState();
}

class _GetOutletScreenState extends State<GetOutletScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          GeolocatorPlatform.instance.getCurrentPosition().then((value) async {
        List<Category> categories = await CategoryService().getCatagory();

        //35000
        List<Outlet> outlets = await OutletService().getNearbyOutlets(context);
        Map<String, List<Outlet>> a = {};
        for (int i = 0; i < outlets.length; i++) {
          if (outlets[i].beatID != null) {
            if (a.keys.contains(outlets[i].beatID)) {
              a[outlets[i].beatID]?.add(outlets[i]);
            } else {
              a[outlets[i].beatID!] = [outlets[i]];
            }
          }
        }

        //75*200
        List<Distributor> distributors =
            await DistributorService().getDistributor();

        for (var z in distributors) {
          for (var element in z.beats) {
            element.outlet = a[element.id] ?? [];
          }
        }
        return [outlets, distributors, categories, value];
      }),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Outlet> outletLatLng = snapshot.data[0];
          List<Distributor> distributors = snapshot.data[1];
          List<Category> categories = snapshot.data[2];
          Position position = snapshot.data[3];
          final controller = mp.MapController(
            location: LatLng(position.latitude, position.longitude),
            zoom: 17,
          );
          return RedMapScreen(
              outletLatLng,
              widget.redRadius,
              controller,
              LatLng(position.latitude, position.longitude),
              distributors,
              categories);
        }
        return SplashScreen(localhost);
      },
    );
  }
}
