import 'package:flutter/material.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

class Outlet {
  String id;
  int? videoID;
  String? videoName;
  int categoryID;
  int? newcategoryID;
  String categoryName;
  String? beatID;
  String? dateTime;
  String outletName;
  double lat;
  double lng;
  String? md5;
  String imageURL;
  Marker? marker;
  bool deactivated;

  Outlet(
      {required this.id,
      this.videoID,
      this.videoName,
      required this.categoryID,
      required this.categoryName,
      this.beatID,
      this.dateTime,
      required this.outletName,
      required this.lat,
      required this.lng,
      this.md5,
      required this.imageURL, // this.deactivated,
      this.marker, required this.deactivated});

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      id: json["id"],
      videoID: json["videoID"] == null ? null : int.parse(json["videoID"]),
      categoryID: int.parse(json["category"]),
      videoName: json["videoName"],
      categoryName: json["categoryName"],
      beatID: json["beatID"],
      dateTime: json["timeStamp"],
      outletName: json["name"],
      lat: double.parse(json["lat"]),
      lng: double.parse(json["lng"]),
      md5: json["md5"],
      imageURL: json["imageURL"],
      deactivated: json["deactivated"] == "False" ? false:true,  //with capital F and T
    );
  }
}
