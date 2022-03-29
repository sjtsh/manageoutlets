import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:http/http.dart' as http;

import '../database.dart';

class CategoryService{

  Future <List<Category>> getCatagory(BuildContext context) async {
    int checkStatus = 0;
    while (checkStatus != 200) {
      try{
        Response res = await http.get(
          Uri.parse("$localhost/category"),
        );
        print("category");
        if (res.statusCode == 200) {
          Map<String, dynamic> a = jsonDecode(res.body);

          List<Category> categories = [];
          for (String i in a.keys) {
            categories.add(Category(a[i]!, int.parse(i)));
          }
          return categories;
        }
        return [];
      }on SocketException{
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