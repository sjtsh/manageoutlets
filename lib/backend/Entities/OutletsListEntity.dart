import 'package:flutter/material.dart';
import 'package:manage_outlets/backend/Entities/Outlet.dart';

import 'User.dart';

class Beat {
  int? id;
  Color? color;
  int? status;
  int? userID;
  String beatName;
  List<Outlet> outlet;

  Beat(this.beatName, this.outlet,
      {this.id, this.color, this.userID, this.status});

  factory Beat.fromJson(Map<String, dynamic> json) {
    List<dynamic> outletsMap = json["outlet"];
    return Beat(json["name"],
        outletsMap
            .map((e) => Outlet.fromJson(e))
            .toList(),
        id: int.parse(json["id"].toString()),
        status: int.parse(json["status"].toString()),
        userID: int.parse(json["user"].toString()));
  }
}
