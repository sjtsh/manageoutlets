import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';
import 'package:latlng/latlng.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';

import '../backend/Entities/Distributor.dart';
import '../backend/Entities/Outlet.dart';
import 'mapscreen.dart';

class RedMapScreen extends StatefulWidget {
  final List<Outlet>
      outletLatLng; //this is the all of the outlets including invisible ones
  final double redRadius; //this is the max red radius for the slider
  final controller;
  final LatLng myPosition; //this is the position of the user
  final List<Distributor> distributors;
  final List<Category> categories;

  RedMapScreen(this.outletLatLng, this.redRadius, this.controller,
      this.myPosition, this.distributors, this.categories);

  @override
  State<RedMapScreen> createState() => _RedMapScreenState();
}

class _RedMapScreenState extends State<RedMapScreen> {
  List<Outlet> bluegreyIndexes = [];
  double redDistance = 0;
  LatLng? center; // this the point from which the latlng will be calculated
  List<Outlet> myOutlets = [];
  bool isDeactivated = false;
  List<Outlet> removePermPositions = [];

  setRemovePermPositions(List<Outlet> removePositions) {
    setState(() {
      removePermPositions = removePositions;
    });
  }

  changeDeactivated(bool isDeactivated) {
    setState(() {
      this.isDeactivated = isDeactivated;
      myOutlets = widget.outletLatLng.where((element) {
        if (isDeactivated) {
          return GeolocatorPlatform.instance.distanceBetween(element.lat,
              element.lng, center!.latitude, center!.longitude) <
              redDistance;
        } else {
          return GeolocatorPlatform.instance.distanceBetween(element.lat,
              element.lng, center!.latitude, center!.longitude) <
              redDistance &&
              element.deactivated == isDeactivated;
        }
      }).toList();
    });
  }

  setTempRedRadius(double a) {
    print(widget.outletLatLng.length);
    setState(() {
      redDistance = a;
    });
    if (center != null) {
      myOutlets = widget.outletLatLng.where((element) {
        if (isDeactivated) {
          return GeolocatorPlatform.instance.distanceBetween(element.lat,
                  element.lng, center!.latitude, center!.longitude) <
              redDistance;
        } else {
          return GeolocatorPlatform.instance.distanceBetween(element.lat,
                      element.lng, center!.latitude, center!.longitude) <
                  redDistance &&
              element.deactivated == isDeactivated;
        }
      }).toList();
    }
  }

  changeCenter(LatLng location) {
    setState(() {
      removePermPositions = [];
      center = LatLng(location.latitude, location.longitude);
      myOutlets = widget.outletLatLng.where((element) {
        if (isDeactivated) {
          return GeolocatorPlatform.instance.distanceBetween(element.lat,
              element.lng, center!.latitude, center!.longitude) <
              redDistance;
        } else {
          return GeolocatorPlatform.instance.distanceBetween(element.lat,
              element.lng, center!.latitude, center!.longitude) <
              redDistance &&
              element.deactivated == isDeactivated;
        }
      }).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.outletLatLng.asMap().entries.forEach((element) {
      if (element.value.beatID != null) {
        bluegreyIndexes.add(element.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MapScreen(
        myOutlets,
        widget.redRadius,
        widget.controller,
        bluegreyIndexes,
        redDistance,
        setTempRedRadius,
        center,
        changeCenter,
        widget.distributors,
        widget.categories,
        removePermPositions,
        setRemovePermPositions,
        changeDeactivated,
        isDeactivated);
  }
}
