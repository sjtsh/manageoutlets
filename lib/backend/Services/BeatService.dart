import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:manage_outlets/backend/Entities/OutletsListEntity.dart';
import 'package:http/http.dart' as http;

import '../Entities/Outlet.dart';
import '../database.dart';

class BeatService {
  Future<bool> updateOutlets(
      List<Beat> beat, int distributorID, BuildContext context) async {
    int statusCode = 200;
    for (var element in beat) {
      Map<String, dynamic> aJson = {};
      aJson["distributor"] = distributorID.toString();
      aJson["beat"] = element.id;
      aJson["beatName"] = element.beatName;
      aJson["outlets"] = {};

      for (Outlet element in element.outlet) {
        aJson["outlets"][element.id.toString()] = {};
        aJson["outlets"][element.id.toString()]["videoID"] =
            element.videoID.toString();
        aJson["outlets"][element.id.toString()]["beatID"] =
            element.beatID.toString();
        aJson["outlets"][element.id.toString()]["categoryID"] =
            element.categoryID.toString();
        aJson["outlets"][element.id.toString()]["dateTime"] =
            element.dateTime.toString();
        aJson["outlets"][element.id.toString()]["outletName"] =
            element.outletName.toString();
        aJson["outlets"][element.id.toString()]["lat"] = element.lat.toString();
        aJson["outlets"][element.id.toString()]["lng"] = element.lng.toString();
        aJson["outlets"][element.id.toString()]["md5"] = element.md5.toString();
        aJson["outlets"][element.id.toString()]["imageURL"] =
            element.imageURL.toString();
        aJson["outlets"][element.id.toString()]["deactivated"] = "true";
      }

      for (Outlet element in element.deactivated) {
        aJson["outlets"][element.id.toString()] = {};
        aJson["outlets"][element.id.toString()]["videoID"] =
            element.videoID.toString();
        aJson["outlets"][element.id.toString()]["beatID"] =
            element.beatID.toString();
        aJson["outlets"][element.id.toString()]["categoryID"] =
            element.categoryID.toString();
        aJson["outlets"][element.id.toString()]["dateTime"] =
            element.dateTime.toString();
        aJson["outlets"][element.id.toString()]["outletName"] =
            element.outletName.toString();
        aJson["outlets"][element.id.toString()]["lat"] = element.lat.toString();
        aJson["outlets"][element.id.toString()]["lng"] = element.lng.toString();
        aJson["outlets"][element.id.toString()]["md5"] = element.md5.toString();
        aJson["outlets"][element.id.toString()]["imageURL"] =
            element.imageURL.toString();
        aJson["outlets"][element.id.toString()]["deactivated"] = "false";
      }

      Response res = await http.post(
        Uri.parse("$localhost/outlet/update"),
        body: aJson,
      );
      if (res.statusCode != 200) {
        statusCode = res.statusCode;
      }
    }

    if (statusCode == 200) {
      return true;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("UNABLE TO CONNECT"),
    ));
    print("UNABLE");
    return false;
  }
}
