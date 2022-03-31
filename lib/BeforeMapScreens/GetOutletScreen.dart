import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:manage_outlets/BeforeMapScreens/SplashScreen.dart';
import 'package:manage_outlets/backend/Entities/Distributor.dart';
import 'package:manage_outlets/backend/Entities/User.dart';
import 'package:manage_outlets/backend/Services/CategoryService.dart';
import 'package:manage_outlets/backend/Services/DistributorService.dart';
import 'package:map/map.dart' as mp;

import 'package:latlng/latlng.dart';

import '../MapRelatedComponents/RedMapScreen.dart';
import '../backend/Entities/Category.dart';
import '../backend/Entities/Outlet.dart';
import '../backend/Entities/OutletsListEntity.dart';
import '../backend/Services/OutletService.dart';
import '../backend/Services/UserService.dart';
import '../backend/database.dart';


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
        List<Category> categories = await CategoryService().getCatagory(context);
        List<User> users  = await UserService().getUsers();
        List<Outlet> outlets = await OutletService().getNearbyOutlets(context);
        List<Distributor> distributors =
            await DistributorService().getDistributor(context);
        return [outlets, distributors, categories, value, users];
      }),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Outlet> outletLatLng = snapshot.data[0];
          List<Distributor> distributors = snapshot.data[1];
          List<Category> categories = snapshot.data[2];
          Position position = snapshot.data[3];
          List<User> users = snapshot.data[4];
          final controller = mp.MapController(
            location: LatLng(position.latitude, position.longitude),
            // location: LatLng(26.778922, 86.0968118),
            zoom: 17,
          );
          return RedMapScreen(
              outletLatLng,
              widget.redRadius,
              controller,
              LatLng(position.latitude, position.longitude),
              distributors,
              categories, users);
        }
        return SplashScreen(localhost);
      },
    );
  }
}
