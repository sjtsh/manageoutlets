import 'dart:convert';

import 'package:http/http.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:http/http.dart' as http;

import '../database.dart';

class CategoryService{

  Future <List<Category>> getCatagory() async {
    Response res = await http.get(
      Uri.parse("$localhost/category"),
    );
    if (res.statusCode == 200) {
      Map<String, dynamic> a = jsonDecode(res.body);
      List<Category> categoryToJson(Map<String, String> data) {
        List<Category> categories = [];
        for (String i in data.keys){
          categories.add(Category(data[i]!, int.parse(i)));
        }
        return categories;
      }
    }
    return[];
  }
}