import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dijkstra/dijkstra.dart';

import 'Entities/Outlet.dart';

List<Outlet> shortestPath(List<Outlet> outlets) {
  List<Outlet> returnableOutletList = [];

  List<List> pairsList = [];
  double mini = outlets[0].lat;
  double maxi = outlets[0].lat;
  Map<List<double>, List<Outlet>> mappedCoordinates = {};

  for (var element in outlets) {
    if (mappedCoordinates.containsKey([element.lat, element.lng])) {
      mappedCoordinates[<double>[element.lat, element.lng]]?.add(element);
    } else {
      pairsList.add([element.lat, element.lng]);
      mappedCoordinates[<double>[element.lat, element.lng]] = [element];
    }
    mini = min(mini, element.lat);
    maxi = max(maxi, element.lat);
  }

  List output1 = Dijkstra.findPathFromPairsList(pairsList, mini, maxi);

  for (List e in output1) {
    returnableOutletList.addAll(mappedCoordinates[e]?.toList() ?? []);
  }

  return [];
}
