import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map/map.dart';

import 'package:latlng/latlng.dart';

import 'GetOutletScreen.dart';
import 'backend/Outlet.dart';

class MergeMap extends StatefulWidget {
  final List<Outlet> visibleOutlets;
  final List<Outlet> focusedOutlets;

  MergeMap(this.visibleOutlets, this.focusedOutlets);

  @override
  State<MergeMap> createState() => _MergeMapState();
}

class _MergeMapState extends State<MergeMap> {
  var controller;
  final TextEditingController textController = TextEditingController();

  Widget _buildMarkerWidget(Offset pos, Color color, bool isLarge) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: isLarge ? 50 : 24,
      height: isLarge ? 50 : 24,
      child: Icon(
        Icons.location_on,
        color: color,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: MapLayoutBuilder(
        controller: controller,
        builder: (context, transformer) {
          Outlet? centerOutlet;
          List<Widget> focusedMarkers = [];
          List<Widget> visibleMarkers = [];
          if (widget.focusedOutlets.isNotEmpty ||
              widget.visibleOutlets.isNotEmpty) {
            if (widget.focusedOutlets.isNotEmpty) {
              centerOutlet = widget.focusedOutlets[0];
            } else {
              centerOutlet = widget.visibleOutlets[0];
            }
            visibleMarkers.addAll(
              List.generate(
                      widget.visibleOutlets.length,
                      (e) => LatLng(widget.visibleOutlets[e].lat,
                          widget.visibleOutlets[e].lng))
                  .map(transformer.fromLatLngToXYCoords)
                  .toList()
                  .map(
                    (pos) => _buildMarkerWidget(pos, Colors.red, false),
                  ),
            );
            focusedMarkers.addAll(
              List.generate(
                      widget.focusedOutlets.length,
                      (e) => LatLng(widget.focusedOutlets[e].lat,
                          widget.focusedOutlets[e].lng))
                  .map(transformer.fromLatLngToXYCoords)
                  .toList()
                  .map(
                    (pos) => _buildMarkerWidget(pos, Colors.blue, false),
                  ),
            );
          }
          return Stack(
            children: [
              Map(
                controller: MapController(
                  location: centerOutlet == null
                      ? LatLng(0, 0)
                      : LatLng(centerOutlet.lat, centerOutlet.lng),
                ),
                builder: (context, x, y, z) {
                  final url =
                      'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';
                  return CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                  );
                },
              ),
              ...visibleMarkers,
              ...focusedMarkers,
            ],
          );
        },
      ),
    );
  }
}