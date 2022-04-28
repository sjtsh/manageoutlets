import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../database.dart';

class VersionCheck {

  Future<String> getVersion() async {
    try{
      Response res = await http.get(Uri.parse("$localhost/checkversion"));
      if (res.statusCode == 200) {
        String version = jsonDecode(res.body);
        return version;
      }
    }catch(e){
      return "failed to  get version";
    }
    return "failed";
  }
}