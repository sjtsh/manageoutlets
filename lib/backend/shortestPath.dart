import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dijkstra/dijkstra.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';

import 'Entities/Outlet.dart';

List<Outlet> shortestPath(List<Outlet> outlets) {
  List<Outlet> temp = outlets;
  int head = 0;


  for (var element in outlets) {
    if (outlets[head].lat < element.lat) {
      head = outlets.indexOf(element);
    }
  }

  Outlet headNode = outlets[head];
  outlets.removeAt(head);
  List<Outlet> sorted = [headNode];

  for (int i = 0; i < temp.length; i++) {

    double mini = Geolocator.distanceBetween(
        headNode.lat, headNode.lng, outlets[0].lat, outlets[0].lng);
    for (int j = 0; j < outlets.length; j++) {
      if (mini >
          Geolocator.distanceBetween(
              headNode.lat, headNode.lng, outlets[j].lat, outlets[j].lng)) {
        head = j;
        headNode = outlets[head];
      }
    }

    sorted.add(outlets[head]);
    outlets.removeAt(head);
  }

  return sorted;
}


// List<int> shortestNumber() {
//   List<int> outlets = [5,6,3,2,3,0,2];
//   List<int> temp = [5,6,3,2,3,0,2];
//   List<int> sorted = [];
//   int head = 0;
//
//   for (var element in outlets) {
//     if (outlets[head] < element) {
//       head = outlets.indexOf(element);
//     }
//   }
//
//   int headNode = outlets[head];
//
//   for (int i = 0; i < temp.length; i++) {
//     int mini = headNode - outlets[0];
//     for (int j = 0; j < outlets.length; j++) {
//       if (mini >(headNode - outlets[0])) {
//         head = j;
//         headNode = outlets[head];
//       }
//     }
//
//     sorted.add(outlets[head]);
//     outlets.removeAt(head);
//   }
//
//   return sorted;
// }
