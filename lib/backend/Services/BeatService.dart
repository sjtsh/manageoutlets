import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:manage_outlets/backend/Entities/OutletsListEntity.dart';
import 'package:http/http.dart' as http;

import '../Entities/Category.dart';
import '../Entities/Outlet.dart';
import '../database.dart';

class BeatService {
  Future<List<Beat>> getBeat(int distributorID) async {
    Response res = await http.get(
      Uri.parse("$localhost/distributorsingle/$distributorID"),
    );
    if (res.statusCode == 200) {
      List<dynamic> b = jsonDecode(res.body);
      List<Beat> beats = b.map((a) {
        List<dynamic> outletsMap = a["outlet"];
        return Beat(
          a["name"],
          outletsMap
              .map((e) => Outlet(
                  id: e["id"],
                  categoryID: int.parse(e["category"]),
                  categoryName: e["categoryName"],
                  outletName: e["name"],
                  lat: double.parse(e["lat"]),
                  lng: double.parse(e["lng"]),
                  imageURL: e["imageURL"],
                  deactivated: e["deactivated"] != "False"))
              .toList(),
          id: a["id"],
          status: a["status"],
          userID: a["user"],
        );
      }).toList();
      return beats;
    }
    throw "[]";
  }

  Future<bool> updateOutlets(
      List<Beat> beat, int distributorID, BuildContext context) async {
    int statusCode = 200;
    for (var element in beat) {
      Map<String, dynamic> aJson = {};
      aJson["beat"] = element.id.toString();
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
      int counter = 0;
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
        counter++;
      }

      aJson["outlets"] = aJson["outlets"].toString();

      Response res = await http.put(
        Uri.parse("$localhost/beat/update"),
        body: aJson,
      );
      print(res.body);
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
