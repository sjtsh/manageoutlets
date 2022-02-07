import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';
import 'package:latlng/latlng.dart';

import 'backend/Outlet.dart';
import 'mapscreen.dart';

class RedMapScreen extends StatefulWidget {
  final List<Outlet> outletLatLng;
  final double redRadius;
  final Function setRedRadius;
  final controller;
  final LatLng myPosition;

  RedMapScreen(this.outletLatLng, this.redRadius, this.setRedRadius,
      this.controller, this.myPosition);

  @override
  State<RedMapScreen> createState() => _RedMapScreenState();
}

class _RedMapScreenState extends State<RedMapScreen> {
  List<Outlet> bluegreyIndexes = [];
  double redDistance = 0;
  LatLng? center; // this the point from which the latlng will be calculated
  List<Outlet> myOutlets = [];

  setTempRedRadius(double a) {
    setState(() {
      redDistance = a;
      if (redDistance == widget.redRadius) {
        widget.setRedRadius(widget.redRadius * 2);
      }
    });
  }

  changeCenter(LatLng location) {
    setState(() {
      center = LatLng(location.latitude, location.longitude);
      myOutlets = widget.outletLatLng.where((element) {
        return GeolocatorPlatform.instance.distanceBetween(
            element.lat,
            element.lng,
            widget.myPosition.latitude,
            widget.myPosition.longitude) <
            redDistance;
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
        changeCenter);
  }
}
