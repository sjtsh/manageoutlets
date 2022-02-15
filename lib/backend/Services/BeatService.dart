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
      aJson["beat"] = element.id.toString();
      aJson["beatName"] = element.beatName.toString();
      aJson["outlets"] = {};
      for (Outlet element in element.outlet) {
        aJson["outlets"][element.id.toString()] = {};
        aJson["outlets"][element.id.toString()]["videoID"] =
            element.videoID.toString();
        aJson["outlets"][element.id.toString()]["beatID"] =
            element.beatID.toString();
        aJson["outlets"][element.id.toString()]["categoryID"] =
            element.newcategoryID.toString();
        aJson["outlets"][element.id.toString()]["dateTime"] =
            element.dateTime.toString().split(":").join("c");
        aJson["outlets"][element.id.toString()]["outletName"] =
            element.outletName.toString();
        aJson["outlets"][element.id.toString()]["lat"] = element.lat.toString();
        aJson["outlets"][element.id.toString()]["lng"] = element.lng.toString();
        aJson["outlets"][element.id.toString()]["md5"] = element.md5.toString();
        aJson["outlets"][element.id.toString()]["imageURL"] =
            element.imageURL.toString();
        aJson["outlets"][element.id.toString()]["deactivated"] = "false";
      }

      for (Outlet element in (element.deactivated ?? [])) {
        aJson["outlets"][element.id.toString()] = {};
        aJson["outlets"][element.id.toString()]["videoID"] =
            element.videoID.toString();
        aJson["outlets"][element.id.toString()]["beatID"] =
            element.beatID.toString();
        aJson["outlets"][element.id.toString()]["categoryID"] =
            element.newcategoryID.toString();
        aJson["outlets"][element.id.toString()]["dateTime"] =
            element.dateTime.toString().split(":").join("c");
        aJson["outlets"][element.id.toString()]["outletName"] =
            element.outletName.toString();
        aJson["outlets"][element.id.toString()]["lat"] = element.lat.toString();
        aJson["outlets"][element.id.toString()]["lng"] = element.lng.toString();
        aJson["outlets"][element.id.toString()]["md5"] = element.md5.toString();
        aJson["outlets"][element.id.toString()]["imageURL"] =
            element.imageURL.toString();
        aJson["outlets"][element.id.toString()]["deactivated"] = "true";
      }

      aJson["outlets"] = aJson["outlets"].toString();
      Response res = await http.put(
        Uri.parse("$localhost/beat/update"),
        body: aJson,
      );
      if (res.statusCode != 200) {
        statusCode = res.statusCode;
      }
    }

    if (statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("SUCCESSFUL"),
      ));
      return true;

    }
    return false;
  }
}
