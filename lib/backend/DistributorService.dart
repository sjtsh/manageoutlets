import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:manage_outlets/backend/Distributor.dart';

import 'Outlet.dart';
import 'database.dart';

class DistributorService {

  Future<List<Distributor>> getDistributor() async {
    // Response res = await http.post(
    //   Uri.parse("$localhost/outlet"),
    //   body: <String, String>{

    //     'distributorName':distributorName,

    //   },
    // );
    // if (res.statusCode == 200) {
    //   List<dynamic> a = jsonDecode(res.body);
    //
    //   return distributorName;
    // } else {
    //   return [];
    // }
    return [];
  }
}
