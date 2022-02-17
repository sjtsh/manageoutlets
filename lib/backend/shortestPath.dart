import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dijkstra/dijkstra.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';

import 'Entities/Outlet.dart';

List<Outlet> shortestPath(List<Outlet> outlets1) {
  List<Outlet> outlets = outlets1;
  int head = 0;

  for (var element in outlets) {
    if (outlets[head].lat > element.lat) {
      head = outlets.indexOf(element);
    }
  }

  Outlet headNode = outlets[head];
  outlets.removeAt(head);

  List<Outlet> sorted = [headNode];

  while (outlets.isNotEmpty) {
    int? changingHead;
    double? mini;
    outlets
        .asMap()
        .entries
        .forEach((element) {
      mini ??= Geolocator.distanceBetween(headNode.lat,
          headNode.lng, element.value.lat, element.value.lng);
      changingHead ??= element.key;
      if (mini! >
          Geolocator.distanceBetween(headNode.lat, headNode.lng,
              element.value.lat, element.value.lng)) {
        changingHead = element.key;
        mini = Geolocator.distanceBetween(headNode.lat, headNode.lng,
            element.value.lat, element.value.lng);
      }
    });
    head = changingHead!;
    headNode = outlets[changingHead!];
    sorted.add(headNode);
    outlets.removeAt(head);
  }

  return sorted;
}

List<Outlet> shortestPathWithHead(List<Outlet> outlets1, LatLng latLng) {
  List<Outlet> outlets = outlets1;
  int head = 0;
  double minDistance = Geolocator.distanceBetween(
      latLng.latitude, latLng.longitude, outlets1[0].lat, outlets1[0].lng);

  for (int i = 0; i < outlets.length; i ++) {
    double a = Geolocator.distanceBetween(
        latLng.latitude, latLng.longitude, outlets[i].lat, outlets[i].lng);
    if (a < minDistance) {
      minDistance = a;
      head = i;
    }
  }

  Outlet headNode = outlets[head];
  outlets.removeAt(head);

  List<Outlet> sorted = [headNode];
  while (outlets.isNotEmpty) {
    int? changingHead;
    double? mini;
    outlets
        .asMap()
        .entries
        .forEach((element) {
      mini ??= Geolocator.distanceBetween(headNode.lat,
          headNode.lng, element.value.lat, element.value.lng);
      changingHead ??= element.key;
      if (mini! >
          Geolocator.distanceBetween(headNode.lat, headNode.lng,
              element.value.lat, element.value.lng)) {
        changingHead = element.key;
        mini = Geolocator.distanceBetween(headNode.lat, headNode.lng,
            element.value.lat, element.value.lng);
      }
    });
    head = changingHead!;
    headNode = outlets[changingHead!];
    sorted.add(headNode);
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
