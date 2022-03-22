import 'package:flutter/material.dart';
import 'package:manage_outlets/backend/Entities/Outlet.dart';

import 'User.dart';

class Beat {
  int? id;
  Color? color;
  int? status;
  User? user;
  String beatName;
  List<Outlet> outlet;
  List<Outlet>? deactivated;

  Beat(this.beatName, this.outlet, {this.id, this.color, this.deactivated, this.user, this.status});

  factory Beat.fromJson(Map<String, dynamic> json) {
    return Beat(
      json["beatName"],
      [],
      id: int.parse(json["id"]),
    );
  }
}
