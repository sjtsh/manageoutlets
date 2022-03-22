import 'package:http/http.dart';
import 'package:manage_outlets/backend/Entities/OutletsListEntity.dart';
import 'package:manage_outlets/backend/Entities/Distributor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../database.dart';

class DistributorService {
  Future<List<Distributor>> getDistributor() async {
    Response res = await http.get(
      Uri.parse("$localhost/distributor"),
    );
    if (res.statusCode == 200) {
      Map<String, dynamic> a = jsonDecode(res.body);
      List<Distributor> distributors = [];
      for (var element in a.keys) {
        List<dynamic> beats = a[element]["beats"];
        distributors.add(
          Distributor(
            int.parse(element.toString()),
            a[element]["name"],
            beats
                .map((e) => Beat.fromJson(e))
                .toList(),
          ),
        );
      }
      return distributors;
    }
    return [];
  }
}

///["distributorID": {"beat":[{"name":"beatName","id":"beatID"}], "name":"distributorName"}}]
///
