import 'package:flutter/material.dart';
import 'package:manage_outlets/backend/Entities/Outlet.dart';

class Beat {
  int? id;
  Color? color;

  String beatName;
  List<Outlet> outlet;
  List<Outlet>? deactivated;

  Beat(this.beatName, this.outlet, {this.id, this.color, this.deactivated});

  factory Beat.fromJson(Map<String, dynamic> json) {
    return Beat(
      json["beatName"],
      [],
      id: int.parse(json["id"]),
    );
  }
}
