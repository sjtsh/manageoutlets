import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:manage_outlets/backend/Entities/OutletsListEntity.dart';
import 'package:http/http.dart' as http;

import '../Entities/Outlet.dart';
import '../database.dart';

class BeatService {
  updateOutlets(
      List<Beat> beat, int distributorID, BuildContext context) async {
    for (var element in beat) {
      Map<String, dynamic> aJson = {};
      aJson["distributor"] = distributorID.toString();
      aJson["beat"] = element.id;
      aJson["beat"] = element.beatName;
      aJson["outlets"] = [];

      Response res = await http.post(
        Uri.parse("$localhost/outlet/insert"),
        body: aJson,
      );

      if (res.statusCode == 200) {
        List<dynamic> a = jsonDecode(res.body);
        List<Outlet> outlets = a.map((e) => Outlet.fromJson(e)).toList();
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("UNABLE TO CONNECT"),
      ));
      print("UNABLE");
    }
  }
}
