import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:manage_outlets/backend/Entities/OutletsListEntity.dart';
import 'package:manage_outlets/backend/Entities/Distributor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlng/latlng.dart';

import '../database.dart';

class DistributorService {
  Future<List<Distributor>> getDistributor(BuildContext context) async {
    int checkStatus = 0;
    while (checkStatus != 200) {
      try {
        Response res = await http.get(
          Uri.parse("$localhost/distributor/"),
        );
        if (res.statusCode == 200) {
          Map<String, dynamic> a = jsonDecode(res.body);
          List<Distributor> distributors = [];
          for (var element in a.keys) {
            List<dynamic> beats = a[element]["beats"];
            Map<String, dynamic> boundary = a[element]["boundary"];

            distributors.add(
              Distributor(
                  int.parse(element.toString()),
                  a[element]["name"],
                  beats.map((e) => Beat.fromJson(e, a[element]["name"])).toList(),
                  boundary.entries.map((e) {
                    Map<String, dynamic> a = e.value;
                    return LatLng(a["lat"], a["lng"]);
                  }).toList()),
            );
          }
          return distributors;
        }
        return [];
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

  Future<Distributor> createDistributor(
      String name, List<LatLng> boundary) async {
    Map<String, String> boundaries = {};
    boundary.asMap().entries.forEach((element) {
      boundaries[(element.key + 1).toString()] = {
        "lat": element.value.latitude.toString(),
        "lng": element.value.longitude.toString()
      }.toString();
    });
    Response res = await http.post(
      Uri.parse("$localhost/distributor/create"),
      body:{"name": name, "boundary": boundaries.toString()},
    );
    if (res.statusCode == 200) {
      String a = jsonDecode(res.body).toString();
      if (a == "false") {
        throw "Unsucessful";
      } else {
        return Distributor(int.parse(a), name, [], boundary);
      }
    }
    throw "Unsucessful";
  }

  Future<bool> updateDistributor(
      Beat beat, Distributor distributor, String newBeatName) async {
    Response res = await http.put(
      Uri.parse("$localhost/beat/distributor"),
      body: {
        "beat_id": beat.id.toString(),
        "distributor_id": distributor.id.toString(),
        "name": newBeatName,
      },
    );
    print(res.body);
    if (res.statusCode == 200) {
      bool a = jsonDecode(res.body);
      return a;
    }
    throw "Unsucessful";
  }
}
