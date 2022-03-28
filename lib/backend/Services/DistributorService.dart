import 'dart:io';
import 'dart:math';

import 'package:http/http.dart';
import 'package:manage_outlets/backend/Entities/OutletsListEntity.dart';
import 'package:manage_outlets/backend/Entities/Distributor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../database.dart';

class DistributorService {
  Future<List<Distributor>> getDistributor() async {
    int checkStatus = 0;
    while (checkStatus != 200) {
      try{
        Response res = await http.get(
          Uri.parse("$localhost/distributor/"),
        );
        print("distributors");

        if (res.statusCode == 200) {
          Map<String, dynamic> a = jsonDecode(res.body);
          List<Distributor> distributors = [];
          for (var element in a.keys) {
            List<dynamic> beats = a[element]["beats"];
            distributors.add(
              Distributor(
                int.parse(element.toString()),
                a[element]["name"],
                beats.map((e) => Beat.fromJson(e)).toList(),
              ),
            );
          }
          return distributors;
        }
        return [];
      }on SocketException{
        print(" $e Failed Loading Distributor");
      }
    }
    return [];
  }

  Future<Distributor> createDistributor(String name) async {
    Response res = await http
        .post(Uri.parse("$localhost/distributor/create"), body: {"name": name});
    if (res.statusCode == 200) {
      String a = jsonDecode(res.body).toString();
      if (a == "false") {
        throw "Unsucessful";
      } else {
        return Distributor(int.parse(a), name, []);
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
