import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dijkstra/dijkstra.dart';
import 'package:geolocator/geolocator.dart';

import 'Entities/Outlet.dart';

List<Outlet> shortestPath(List<Outlet> outlets) {
  // List<Outlet> returnableOutletList = [];
  //
  // List<List> pairsList = [];
  // int maximumFloat = 0;
  // Map<List<int>, List<Outlet>> mappedCoordinates = {};
  // for (var element in outlets) {
  //   maximumFloat =
  //       max((element.lat).toString().split(".").last.length, maximumFloat);
  //
  //   maximumFloat =
  //       max((element.lng).toString().split(".").last.length, maximumFloat);
  //
  // }
  // maximumFloat = 4;
  // int mini = (outlets[0].lat * pow(10,maximumFloat))~/1;
  // int maxi = (outlets[0].lng * pow(10,maximumFloat))~/1;
  // for (var element in outlets) {
  //   int aLat = (element.lat * pow(10,maximumFloat))~/1;
  //   int aLng = (element.lng * pow(10,maximumFloat))~/1;
  //   if (mappedCoordinates.containsKey([aLat, aLng])) {
  //     mappedCoordinates[[aLat, aLng]]?.add(element);
  //   } else {
  //     pairsList.add([aLat, aLng]);
  //     mappedCoordinates[[aLat, aLng]] = [element];
  //   }
  //   mini = min(mini, aLat);
  //   maxi = max(maxi, aLng);
  // }
  // print(pairsList.toString() + " " + mini.toString() +" " + maxi.toString());
  //
  // List output1 = Dijkstra.findPathFromPairsList(pairsList, maxi, mini);
  // print(output1);
  // for (var e in output1) {
  //   returnableOutletList.addAll(mappedCoordinates[e]?.toList() ?? []);
  // }

  return outlets;
}