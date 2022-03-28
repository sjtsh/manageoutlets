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
    int checkStatus = 0;
    while (checkStatus != 200) {
      try{
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
      } catch(e){
        print("Failed loading beats");
      }
    }
    return [];
  }

    Future<bool> updateOutlets(List<Beat> beat, int distributorID,
        BuildContext context, Function setNewBeats) async {
      int statusCode = 200;
      for (Beat element in beat) {
        Map<String, dynamic> aJson = {"outlets": {}};
        aJson["beat"] = element.id.toString();
        for (Outlet element in element.outlet) {
          aJson["outlets"][element.id.toString()] = {};
          aJson["outlets"][element.id.toString()]["videoID"] = element.videoID;
          aJson["outlets"][element.id.toString()]["beatID"] = element.beatID;
          aJson["outlets"][element.id.toString()]["categoryID"] =
              element.newcategoryID;
          aJson["outlets"][element.id.toString()]["dateTime"] =
              DateTime.tryParse(element.dateTime ?? "");
          aJson["outlets"][element.id.toString()]["outletName"] =
              element.outletName;
          aJson["outlets"][element.id.toString()]["lat"] = element.lat;
          aJson["outlets"][element.id.toString()]["lng"] = element.lng;
          aJson["outlets"][element.id.toString()]["md5"] = element.md5;
          aJson["outlets"][element.id.toString()]["imageURL"] =
              element.imageURL;
          aJson["outlets"][element.id.toString()]["deactivated"] = "false";
        }
        for (Outlet element in (element.deactivated ?? [])) {
          aJson["outlets"][element.id.toString()] = {};
          aJson["outlets"][element.id.toString()]["videoID"] = element.videoID;
          aJson["outlets"][element.id.toString()]["beatID"] = element.beatID;
          aJson["outlets"][element.id.toString()]["categoryID"] =
              element.newcategoryID;
          aJson["outlets"][element.id.toString()]["dateTime"] =
              element.dateTime;
          aJson["outlets"][element.id.toString()]["outletName"] =
              element.outletName;
          aJson["outlets"][element.id.toString()]["lat"] = element.lat;
          aJson["outlets"][element.id.toString()]["lng"] = element.lng;
          aJson["outlets"][element.id.toString()]["md5"] = element.md5;
          aJson["outlets"][element.id.toString()]["imageURL"] =
              element.imageURL;
          aJson["outlets"][element.id.toString()]["deactivated"] = "true";
        }

        aJson["outlets"] = aJson["outlets"].toString();

        Response res = await http.put(
          Uri.parse("$localhost/beat/update/"),
          body: aJson,
        );
        print(res.body);
        if (res.statusCode != 200) {
          statusCode = res.statusCode;
        }
      }

      if (statusCode == 200) {
        List<Beat> beats = await BeatService().getBeat(distributorID);
        setNewBeats(beats, distributorID);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("SUCCESSFUL"),
        ));
        return true;
      }
      return false;
    }
}
