import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:manage_outlets/backend/Entities/OutletsListEntity.dart';
import 'package:http/http.dart' as http;

import '../../BeforeMapScreens/LocalHostScreen.dart';
import '../Entities/Category.dart';
import '../Entities/Distributor.dart';
import '../Entities/Outlet.dart';
import '../database.dart';

class BeatService {
  Future<List<Beat>> getBeat(
      Distributor distributor, BuildContext context) async {
    try {
      Response res = await http.get(
        Uri.parse("$localhost/distributorsingle/${distributor.id}"),
      );
      if (res.statusCode == 200) {
        List<dynamic> b = jsonDecode(res.body);
        List<Beat> beats = b.map((a) {
          List<dynamic> outletsMap = a["outlet"];
          return Beat(
            a["name"],
            outletsMap.map((e) => Outlet.fromJson(e)).toList(),
            distributor.distributorName,
            id: a["id"],
            status: a["status"],
            userID: a["user"],
          );
        }).toList();
        return beats;
      }
      throw "[]";
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unsuccessful"),
        ),
      );
    }
    return [];
  }

  Future<bool> updateOutlets(List<Beat> beat, Distributor distributor,
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
        aJson["outlets"][element.id.toString()]["imageURL"] = element.imageURL;
        aJson["outlets"][element.id.toString()]["deactivated"] =
            element.deactivated ? "true" : "false";
      }

      aJson["outlets"] = aJson["outlets"].toString();

      Response res = await http.put(
        Uri.parse("$localhost/beat/update/"),
        body: aJson,
      );
      if (res.statusCode != 200) {
        statusCode = res.statusCode;
      }
    }

    if (statusCode == 200) {
      List<Beat> beats = await BeatService().getBeat(distributor, context);
      setNewBeats(beats, distributor.id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("SUCCESSFUL"),
      ));
      return true;
    }
    return false;
  }

  Future<bool> updateOutletToStatus2(
      List<Outlet> outlets,
      int beatID,
      BuildContext context) async {
    int statusCode = 200;
    Map<String, dynamic> aJson = {"outlets": {}};
    aJson["beat"] = beatID.toString();
    for (Outlet element in outlets) {
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
      aJson["outlets"][element.id.toString()]["imageURL"] = element.imageURL;
      aJson["outlets"][element.id.toString()]["deactivated"] =
          element.deactivated ? "true" : "false";
    }

    aJson["outlets"] = aJson["outlets"].toString();

    Response res = await http.put(
      Uri.parse("$localhost/beat/changedistributor/"),
      body: aJson,
    );
    if (res.statusCode != 200) {
      statusCode = res.statusCode;
    }

    if (statusCode == 200) {
    Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_){
        return LocalHostScreen();
      }));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("SUCCESSFUL"),
      ));
      return true;
    }
    return false;
  }

  Future<bool> deleteBeat(int? id, Distributor distributor,
      Function setNewBeats, BuildContext context) async {
    Response res = await http.delete(
      Uri.parse("$localhost/beat/$id/delete/"),
    );
    if (res.statusCode == 200) {
      if (res.body == "true") {
        List<Beat> beats = await BeatService().getBeat(distributor, context);
        setNewBeats(beats, distributor.id);
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
