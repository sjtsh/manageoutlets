import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../Entities/Outlet.dart';
import '../database.dart';

class OutletService {
  Future<List<Outlet>> getNearbyOutlets( context) async {
    Response res = await http.get(
      Uri.parse("$localhost/outlet"),
    );
    print("outlet service");

    List<dynamic> a = jsonDecode(res.body);
    List<Outlet> outlets = a.map((e) => Outlet.fromJson(e)).toList();
    return outlets;
  }
}
