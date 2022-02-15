import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:manage_outlets/backend/database.dart';
import 'package:manage_outlets/addBeatNameDialog.dart';
import 'package:map/map.dart';
import 'backend/Entities/OutletsListEntity.dart';
import 'MapScreenRightPanel.dart';
import 'backend/Entities/Distributor.dart';
import 'backend/Entities/Outlet.dart';
import 'backend/shortestPath.dart';

class MapScreen extends StatefulWidget {
  final List<Outlet>
      outletLatLng; //this is the all of the outlets that is visible
  final double redRadius; //this radius is the max point of the slider
  final LatLng?
      center; // this the point from which the latlng will be calculated
  final Function setTempRedRadius;
  final controller;
  final List<Outlet> bluegreyIndexes;
  final double redDistance;
  final Function changeCenter;
  final List<Distributor> distributors;
  final List<Category> categories;
  final List<Outlet> removePermPositions;
  final Function setRemovePermPositions;

  MapScreen(
    this.outletLatLng,
    this.redRadius,
    this.controller,
    this.bluegreyIndexes,
    this.redDistance,
    this.setTempRedRadius,
    this.center,
    this.changeCenter,
    this.distributors,
    this.categories,
    this.removePermPositions,
    this.setRemovePermPositions,
  );

  @override
  _MapScreenState createState() => _MapScreenState();
}

class MinusButtonIntent extends Intent {}

class AddButtonIntent extends Intent {}

class _MapScreenState extends State<MapScreen> {
  LatLng?
      removeCenter; // this the point from which the latlng will be calculated

  double redRemoveDistance = 0;
  bool _validate = false;

  void refresh() {
    setState(() {});
  }

  setRemoveRedRadius(double a) {
    setState(() {
      redRemoveDistance = a;
    });
    // if (removeCenter != null) {
    //   removeOutlets = widget.outletLatLng.where((element) {
    //     return GeolocatorPlatform.instance.distanceBetween(element.lat,
    //         element.lng, removeCenter!.latitude, removeCenter!.longitude) <
    //         redRemoveDistance;
    //   }).toList();
    // }
  }

  changeRemoveCenter(LatLng location) {
    setState(() {
      removeCenter = LatLng(location.latitude, location.longitude);
      // removeOutlets = widget.outletLatLng.where((element) {
      //   return GeolocatorPlatform.instance.distanceBetween(element.lat,
      //       element.lng, removeCenter!.latitude, removeCenter!.longitude) <
      //       redRemoveDistance;
      // }).toList();
    });
  }

  List<Outlet> redPositions = [];
  List<Outlet> bluePositions = [];
  List<Outlet> removePositions = [];
  List<Outlet> rangeIndexes =
      []; //temporary indexes, this one is according to the widget.center
  List<Beat> blueIndexes = [];

  bool removeActive = false;

  Distributor selectedDropDownItem = Distributor(
    -1,
    "Select Distributor",
    [],
  );

  void _changeDropDownValue(Distributor newValue) {
    setState(() {
      selectedDropDownItem = newValue;
    });
  }

  updateBeat({required Beat formerBeat, required Beat newBeat}) {
    setState(() {
      blueIndexes.remove(formerBeat);
      blueIndexes.add(newBeat);
    });
  }

  removeBeat(Beat beat) {
    setState(() {
      blueIndexes.remove(beat);
    });
  }

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

  Widget _buildMarkerWidgetClear(Offset pos, Color color, bool isLarge) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: isLarge ? 50 : 24,
      height: isLarge ? 50 : 24,
      child: Icon(
        Icons.clear,
        color: color,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.numpadSubtract): MinusButtonIntent(),
        LogicalKeySet(LogicalKeyboardKey.numpadAdd): AddButtonIntent(),
      },
      child: Actions(
        actions: {
          MinusButtonIntent: CallbackAction(
            onInvoke: (intent) {
              setState(() {
                removeActive = !removeActive;
                removeCenter = null;
                setRemoveRedRadius(0.0);
              });
            },
          ),
          AddButtonIntent: CallbackAction(onInvoke: (intent) {
            TextEditingController textController = TextEditingController();
            showDialog(
                context: context,
                builder: (_) {
                  return AddBeatDialogBox(textController, rangeIndexes,
                      blueIndexes, redPositions, widget.setTempRedRadius);
                });
          }),
        },
        child: Scaffold(
          backgroundColor: const Color(0xfff2f2f2),
          body: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.only(top: 12, left: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 2),
                                spreadRadius: 2,
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: MapLayoutBuilder(
                          controller: widget.controller,
                          builder: (context, transformer) {
                            redPositions = widget.outletLatLng;
                            final markerWidgets = [];
                            if (widget.center != null) {
                              List<Outlet> selectedOutlets = [];
                              for (Beat beat in blueIndexes) {
                                selectedOutlets.addAll(beat.outlet);
                              }

                              redPositions = [];
                              rangeIndexes = [];
                              removePositions = [];
                              widget.outletLatLng
                                  .asMap()
                                  .entries
                                  .forEach((element) {
                                if (selectedOutlets.contains(element.value) ||
                                    widget.removePermPositions
                                        .contains(element.value)) {
                                  // bluePositions.add(element.value);
                                } else if (GeolocatorPlatform.instance
                                        .distanceBetween(
                                            element.value.lat,
                                            element.value.lng,
                                            (removeCenter?.latitude ?? 0),
                                            (removeCenter?.longitude ?? 0)) <
                                    redRemoveDistance) {
                                  if (!removePositions
                                      .contains(element.value)) {
                                    removePositions.add(element.value);
                                  }
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
                                      LatLng(
                                          element.value.lat, element.value.lng)
                                    ]
                                        .map(transformer.fromLatLngToXYCoords)
                                        .toList()
                                        .map(
                                          (pos) => _buildMarkerWidget(
                                              pos, Colors.blueGrey, false),
                                        ));
                                  } else {
                                    redPositions.add(element.value);
                                    markerWidgets.addAll([
                                      LatLng(
                                          element.value.lat, element.value.lng)
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
                                      removePositions.length,
                                      (e) => LatLng(removePositions[e].lat,
                                          removePositions[e].lng))
                                  .map(transformer.fromLatLngToXYCoords)
                                  .toList()
                                  .map(
                                    (pos) => _buildMarkerWidget(
                                        pos, Colors.blue, false),
                                  ),
                            );
                            for (int i = 0; i < blueIndexes.length; i++) {
                              markerWidgets.addAll(
                                List.generate(
                                        blueIndexes[i].outlet.length,
                                        (e) => LatLng(
                                            blueIndexes[i].outlet[e].lat,
                                            blueIndexes[i].outlet[e].lng))
                                    .map(transformer.fromLatLngToXYCoords)
                                    .toList()
                                    .map(
                                      (pos) => _buildMarkerWidget(
                                          pos, colorIndex[i], false),
                                    ),
                              );
                            }
                            Widget? homeMarkerWidget;
                            Widget? removeMarkerWidget;
                            if (widget.center != null) {
                              final homeLocation = transformer
                                  .fromLatLngToXYCoords(widget.center!);

                              homeMarkerWidget = _buildMarkerWidget(
                                  homeLocation, Colors.black, true);
                            }

                            if (removeCenter != null) {
                              final homeLocation = transformer
                                  .fromLatLngToXYCoords(removeCenter!);

                              removeMarkerWidget = _buildMarkerWidgetClear(
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
                                LatLng location =
                                    transformer.fromXYCoordsToLatLng(
                                        details.localPosition);

                                Offset clicked =
                                    transformer.fromLatLngToXYCoords(location);
                                if (!removeActive) {
                                  widget.changeCenter(location);
                                } else {
                                  changeRemoveCenter(location);
                                  print("remove marker here");
                                }
                                print(
                                    '${location.latitude}, ${location.longitude}');
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
                                    (removeMarkerWidget != null)
                                        ? removeMarkerWidget
                                        : Container(),
                                    ...markerWidgets,
                                    Positioned(
                                      bottom: 20,
                                      right: 20,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            removeActive = !removeActive;
                                            removeCenter = null;
                                            setRemoveRedRadius(0.0);
                                          });
                                        },
                                        child: Focus(
                                          autofocus: true,
                                          child: Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                color: removeActive
                                                    ? Colors.green
                                                    : Colors.red,
                                                shape: BoxShape.circle),
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    removeActive
                        ? Container(
                            margin: EdgeInsets.only(top: 12, left: 12),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.1))
                              ],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "${removePositions.length.toString()} outlets found in ${redRemoveDistance.toStringAsFixed(2)}m",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 12,
                                    ),
                                    const Text("0 m"),
                                    Expanded(
                                      child: Slider(
                                          activeColor: Colors.green,
                                          inactiveColor:
                                              Colors.green.withOpacity(0.5),
                                          thumbColor: Colors.green,
                                          value: redRemoveDistance,
                                          max: 1000,
                                          min: 0,
                                          label:
                                              "${redRemoveDistance.toStringAsFixed(2)}",
                                          onChanged: (double a) {
                                            setState(() {
                                              setRemoveRedRadius(a);
                                            });
                                          }),
                                    ),
                                    const Text("1000 m"),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        widget.setRemovePermPositions([
                                          ...widget.removePermPositions,
                                          ...removePositions
                                        ]);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(0, 2),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  color: Colors.black
                                                      .withOpacity(0.1))
                                            ]),
                                        child: const Center(
                                          child: Text(
                                            "Remove",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 12, left: 12),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.1))
                              ],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "${redPositions.length.toString()} outlets found in ${widget.redDistance.toStringAsFixed(2)}m",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 12,
                                    ),
                                    const Text("0 m"),
                                    Expanded(
                                      child: Slider(
                                          activeColor: Colors.red,
                                          inactiveColor:
                                              Colors.red.withOpacity(0.5),
                                          thumbColor: Colors.red,
                                          value: widget.redDistance,
                                          max: 2000,
                                          min: 0,
                                          label:
                                              "${widget.redDistance.toStringAsFixed(2)}",
                                          onChanged: (double a) {
                                            setState(() {
                                              widget.setTempRedRadius(a);
                                            });
                                          }),
                                    ),
                                    const Text("2000 m"),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                      clipBehavior: Clip.hardEdge,
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 2),
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                                color: Colors.black
                                                    .withOpacity(0.1))
                                          ]),
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            bluePositions = [];
                                            rangeIndexes = [];
                                            widget.setTempRedRadius(0.0);
                                          });
                                        },
                                        child: const Center(
                                          child: Text(
                                            "CLEAR",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Focus(
                                      autofocus: true,
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        height: 50,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(0, 2),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  color: Colors.black
                                                      .withOpacity(0.1))
                                            ]),
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            TextEditingController
                                                textController =
                                                TextEditingController();
                                            if (redPositions.length != 0) {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return AddBeatDialogBox(
                                                        textController,
                                                        rangeIndexes,
                                                        blueIndexes,
                                                        redPositions,
                                                        widget
                                                            .setTempRedRadius);
                                                  });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      content: Text(
                                                          "Please select outlet")));
                                            }
                                          },
                                          child: const Center(
                                            child: Text(
                                              "ADD",
                                              style: TextStyle(
                                                  color: Colors.white),
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
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: MapScreenRightPanel(
                      widget.categories,
                      widget.distributors,
                      blueIndexes,
                      removeBeat,
                      selectedDropDownItem,
                      _changeDropDownValue,
                      refresh,
                      updateBeat)),
            ],
          ),
        ),
      ),
    );
  }
}
