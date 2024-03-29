import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../Entities/Outlet.dart';
import '../database.dart';

class OutletService {
  Future<List<Outlet>> getNearbyOutlets(context) async {
    int checkStatus = 0;
    while (checkStatus != 200) {
      Response res = await http.get(
        Uri.parse("$localhost/outlet"),
      );
      try {
        List<dynamic> a = jsonDecode(res.body);
        List<Outlet> outlets = a.map((e) => Outlet.fromJson(e)).toList();
        print(outlets.length);
        return outlets;
      } on SocketException {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unsuccessful"),
          ),
        );
      }
    }
    return [];
  }
}
