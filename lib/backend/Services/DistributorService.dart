import 'package:http/http.dart';
import 'package:manage_outlets/Entity/OutletsListEntity.dart';
import 'package:manage_outlets/backend/Entities/Distributor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../database.dart';

class DistributorService {
  Future<List<Distributor>> getDistributor() async {
    Response res = await http.get(
      Uri.parse("$localhost/distributor"),
    );
    print(res.body);
    if (res.statusCode == 200) {
      Map<String, dynamic> a = jsonDecode(res.body);
      List<Distributor> distributors = [];
      for (String element in a.keys) {
        List<dynamic> beats = a[element]["beats"];
        distributors.add(Distributor(
            a[element]["name"],
            beats
                .map((e) => Beat(
                      e["name"],
                      [],
                      id: e["id"],
                    ))
                .toList(),
            id: int.parse(element)));
      }
      return distributors;
    }
    return [];
  }
}

///["distributorID": {"beat":[{"name":"beatName","id":"beatID"}], "name":"distributorName"}}]
///
