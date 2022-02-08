import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../Entities/Outlet.dart';
import '../database.dart';

class OutletService {

  Future<List<Outlet>> getNearbyOutlets(double distance, double lat, double lng) async {
    // Response res = await http.post(
    //   Uri.parse("$localhost/outlet"),
    //   body: <String, String>{
    //     'lat': lat.toString(),
    //     'lng': lng.toString(),
    //     'distance': distance.toString(),
    //   },
    // );
    // if (res.statusCode == 200) {
    //   List<dynamic> a = jsonDecode(res.body);
    //   List<Outlet> outlets = a.map((e) => Outlet.fromJson(e)).toList();
    //   print(outlets.length);
    //   return outlets;
    // } else {
    //   return [];
    // }
    return Future.value([]);
  }
}
