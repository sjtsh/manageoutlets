import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:http/http.dart' as http;

import '../Entities/Outlet.dart';
import '../Entities/OutletsListEntity.dart';
import '../Entities/User.dart';
import '../database.dart';

class UserService {

  Future<bool> assignOutlets(
      List<Beat> beat, int distributorID, BuildContext context,) async { //only makes sense for one since a user id is there
    int statusCode = 200;
    for (var element in beat) {
      Map<String, dynamic> aJson = {};
      aJson["distributor"] = distributorID.toString();
      aJson["beat"] = element.id.toString();
      aJson["user"] = element.userID.toString();
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
      aJson["outlets"] = aJson["outlets"].toString();
      Response res = await http.put(
        Uri.parse("$localhost/beat/assign/"),
        body: aJson,
      );
      if (res.statusCode != 200) {
      statusCode = 200;
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
  Future<List<User>> getUsers() async {
    Response res = await http.get(
      Uri.parse("$localhost/user"),
    );
    if (res.statusCode == 200) {
      Map<String, dynamic> a = jsonDecode(res.body);

      List<User> users = [];
      for (String i in a.keys) {
        users.add(
          User(
            int.parse(i),
            a[i]!,
          ),
        );
      }
      return users;
    }
    return [];
  }
}
