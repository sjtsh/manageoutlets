import 'package:dijkstra/dijkstra.dart';
import 'package:flutter/material.dart';
import 'package:manage_outlets/backend/Entities/Distributor.dart';
import 'package:manage_outlets/backend/Entities/OutletsListEntity.dart';
import 'package:manage_outlets/backend/Services/BeatService.dart';
import 'package:manage_outlets/backend/Services/DistributorService.dart';
import 'package:manage_outlets/backend/Services/OutletService.dart';
import 'BeforeMapScreens/LocalHostScreen.dart';
import 'backend/shortestPath.dart';

void main() {
  runApp(MyApp());
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
      // home: GetOutletScreen(1000000),
      home: LocalHostScreen(),
    );
  }
}
