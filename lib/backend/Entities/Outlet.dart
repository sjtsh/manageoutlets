import 'package:flutter/material.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

class Outlet {
  String id;
  String? videoName;
  String categoryName;
  String? beatID;
  String dateTime;
  String outletName;
  double lat;
  double lng;
  String md5;
  String imageURL;
  Marker? marker;

  Outlet(
      {required this.id,
      this.videoName,
      required this.categoryName,
      this.beatID,
      required this.dateTime,
      required this.outletName,
      required this.lat,
      required this.lng,
      required this.md5,
      required this.imageURL, this.marker});

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      id: json["id"],
      videoName: json["videoName"],
      categoryName: json["categoryName"],
      beatID: json["beatID"],
      dateTime: json["timeStamp"],
      outletName: json["name"],
      lat: double.parse(json["lat"]),
      lng: double.parse(json["lng"]),
      md5: json["md5"],
      imageURL: json["imageURL"],
    );
  }
}
