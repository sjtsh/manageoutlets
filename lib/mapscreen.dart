import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'backend/Outlet.dart';
import 'backend/Outlet.dart';
import 'merge/OutletMergeScreen.dart';
import 'merge/mergescreen.dart';

class MapScreen extends StatefulWidget {
  final List<Outlet> outletLatLng;
  final double redRadius;
  final LatLng?
      center; // this the point from which the latlng will be calculated
  final Function setTempRedRadius;
  final controller;
  final List<Outlet> bluegreyIndexes;
  final double redDistance;
  final Function changeCenter;

  MapScreen(
      this.outletLatLng,
      this.redRadius,
      this.controller,
      this.bluegreyIndexes,
      this.redDistance,
      this.setTempRedRadius,
      this.center,
      this.changeCenter);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double blueDistance = 0;
  List<Outlet> markerPositions1 = [];
  List<Outlet> markerPositions2 = [];
  List<Outlet> blueIndexes = []; //permanent indexes, this one will be cleared
  List<Outlet> rangeIndexes =
      []; //temporary indexes, this one is according to the widget.center

  void _onDoubleTap() {
    widget.controller.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;

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
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_rounded)),
                      Expanded(
                        child: Center(
                          child: Text(
                            "${blueIndexes.length.toString()} Added",
                            style: TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.transparent,
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: MapLayoutBuilder(
                    controller: widget.controller,
                    builder: (context, transformer) {
                      markerPositions1 = [];
                      markerPositions2 = widget.outletLatLng;
                      final markerWidgets = [];
                      if (widget.center != null) {
                        markerPositions2 = [];
                        rangeIndexes = [];
                        widget.outletLatLng.asMap().entries.forEach((element) {
                          if (blueIndexes.contains(element.value)) {
                            markerPositions1.add(element.value);
                          } else if (GeolocatorPlatform.instance
                                  .distanceBetween(
                                      element.value.lat,
                                      element.value.lng,
                                      widget.center!.latitude,
                                      widget.center!.longitude) <
                              blueDistance) {
                            rangeIndexes.add(element.value);
                            markerPositions1.add(element.value);
                          } else if (GeolocatorPlatform.instance
                                  .distanceBetween(
                                      element.value.lat,
                                      element.value.lng,
                                      widget.center!.latitude,
                                      widget.center!.longitude) <
                              widget.redDistance) {
                            if (widget.bluegreyIndexes
                                .contains(element.value)) {
                              markerWidgets.addAll([
                                LatLng(element.value.lat, element.value.lng)
                              ]
                                  .map(transformer.fromLatLngToXYCoords)
                                  .toList()
                                  .map(
                                    (pos) => _buildMarkerWidget(
                                        pos, Colors.blueGrey, false),
                                  ));
                            } else {
                              markerWidgets.addAll([
                                LatLng(element.value.lat, element.value.lng)
                              ]
                                  .map(transformer.fromLatLngToXYCoords)
                                  .toList()
                                  .map(
                                    (pos) => _buildMarkerWidget(
                                        pos, Colors.red, false),
                                  ));
                            }
                          }
                        });
                      }
                      markerWidgets.addAll(
                        List.generate(
                                markerPositions1.length,
                                (e) => LatLng(markerPositions1[e].lat,
                                    markerPositions1[e].lng))
                            .map(transformer.fromLatLngToXYCoords)
                            .toList()
                            .map(
                              (pos) =>
                                  _buildMarkerWidget(pos, Colors.blue, false),
                            ),
                      );
                      Widget? homeMarkerWidget;
                      if (widget.center != null) {
                        final homeLocation =
                            transformer.fromLatLngToXYCoords(widget.center!);

                        homeMarkerWidget = _buildMarkerWidget(
                            homeLocation, Colors.black, true);
                      }
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onDoubleTap: _onDoubleTap,
                        onScaleStart: (ScaleStartDetails details) {
                          _dragStart = details.focalPoint;
                          _scaleStart = 1.0;
                        },
                        onScaleUpdate: (ScaleUpdateDetails details) {
                          final scaleDiff = details.scale - _scaleStart;
                          _scaleStart = details.scale;

                          if (scaleDiff > 0) {
                            widget.controller.zoom += 0.02;
                            setState(() {});
                          } else if (scaleDiff < 0) {
                            widget.controller.zoom -= 0.02;
                            setState(() {});
                          } else {
                            final now = details.focalPoint;
                            final diff = now - _dragStart!;
                            _dragStart = now;
                            widget.controller.drag(diff.dx, diff.dy);
                            setState(() {});
                          }
                        },
                        onTapUp: (details) {
                          LatLng location = transformer
                              .fromXYCoordsToLatLng(details.localPosition);

                          Offset clicked =
                              transformer.fromLatLngToXYCoords(location);
                          widget.changeCenter(location);
                          setState(() {
                            blueDistance = 0;
                          });
                          print('${location.latitude}, ${location.longitude}');
                          print('${clicked.dx}, ${clicked.dy}');
                          print(
                              '${details.localPosition.dx}, ${details.localPosition.dy}');
                        },
                        child: Listener(
                          behavior: HitTestBehavior.opaque,
                          onPointerSignal: (event) {
                            if (event is PointerScrollEvent) {
                              final delta = event.scrollDelta;

                              widget.controller.zoom -= delta.dy / 1000.0;
                              setState(() {});
                            }
                          },
                          child: Stack(
                            children: [
                              Map(
                                controller: widget.controller,
                                builder: (context, x, y, z) {
                                  final url =
                                      'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';
                                  return CachedNetworkImage(
                                    imageUrl: url,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              (homeMarkerWidget != null)
                                  ? homeMarkerWidget
                                  : Container(),
                              ...markerWidgets,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "${rangeIndexes.length} outlets found in ${widget.redDistance.toStringAsFixed(2)}m",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        Text("0 m"),
                        Expanded(
                          child: Slider(
                              activeColor: Colors.red,
                              inactiveColor: Colors.red.withOpacity(0.5),
                              thumbColor: Colors.red,
                              value: widget.redDistance,
                              max: widget.redRadius,
                              min: 0,
                              label: "${widget.redDistance.toStringAsFixed(2)}",
                              onChanged: (double a) {
                                widget.setTempRedRadius(a);
                              }),
                        ),
                        Text("${widget.redRadius} m"),
                        SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        Text("0 m"),
                        Expanded(
                          child: Slider(
                              activeColor: Colors.blue,
                              inactiveColor: Colors.blue.withOpacity(0.5),
                              thumbColor: Colors.blue,
                              value: blueDistance,
                              max: widget.redDistance,
                              min: 0,
                              label: "$blueDistance",
                              onChanged: (double a) {
                                setState(() {
                                  blueDistance = a;
                                });
                              }),
                        ),
                        Text("${widget.redDistance.toStringAsFixed(2)} m"),
                        SizedBox(
                          width: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              blueIndexes.addAll(rangeIndexes);
                            });
                          },
                          child: Container(
                            width: 100,
                            color: Colors.green,
                            height: 60,
                            child: Center(
                              child: Text(
                                "Add",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            blueDistance = 0;
                            blueIndexes = [];

                            rangeIndexes = [];
                          });
                        },
                        child: Container(
                          color: Colors.red,
                          height: 60,
                          child: Center(
                            child: Text(
                              "CLEAR",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return MergeScreen(blueIndexes);
                              },
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.green,
                          height: 60,
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(color: Colors.green,),
          ),
        ],
      ),
    );
  }
}
