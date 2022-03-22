import 'dart:convert';

import 'package:http/http.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:http/http.dart' as http;

import '../Entities/User.dart';
import '../database.dart';

class UserService {
  Future<List<User>> getUsers() async {
    Response res = await http.get(
      Uri.parse("$localhost/user"),
    );
    if (res.statusCode == 200) {
      Map<String, dynamic> a = jsonDecode(res.body);

      List<User> users = [];
      for (String i in a.keys) {
        users.add(
          User(
            int.parse(i),
            a[i]!,
          ),
        );
      }
      return users;
    }
    return [];
  }
}
