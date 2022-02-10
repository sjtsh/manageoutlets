import 'package:dijkstra/dijkstra.dart';
import 'package:flutter/material.dart';
import 'package:manage_outlets/backend/Services/DistributorService.dart';
import 'MergeMap.dart';
import 'GetOutletScreen.dart';
import 'backend/Services/CategoryService.dart';

void main() {
  List<List> pairsList = [
    [0, 2],
    [3, 4],
    [0, 6],
    [5, 6],
    [2, 3],
    [0, 1],
    [0, 4],
    [0, 113],
    [113, 114],
    [111, 112]
  ];
  int from = 114;
  int to = 5;
  var output1 = Dijkstra.findPathFromPairsList(pairsList, from, to);
  print("output1:");
  print(output1);


  runApp(MyApp());
  CategoryService().getCatagory();
}


class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Map Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: GetOutletScreen(1000000),
    );
  }
}
