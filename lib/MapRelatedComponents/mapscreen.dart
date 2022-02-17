import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:manage_outlets/DraggableMarker.dart';
import 'package:manage_outlets/MapRelatedComponents/SearchOutlets.dart';
import 'package:manage_outlets/ShapePainteer.dart';
import 'package:manage_outlets/Sliders/BlueSlider.dart';
import 'package:manage_outlets/Sliders/GreenSlider.dart';
import 'package:manage_outlets/Sliders/RedSlider.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:manage_outlets/backend/database.dart';
import 'package:manage_outlets/DialogBox/addBeatNameDialog.dart';
import 'package:map/map.dart';
import '../backend/Entities/OutletsListEntity.dart';
import '../backend/Entities/PathPoint.dart';
import 'MapScreenRightPanel.dart';
import '../backend/Entities/Distributor.dart';
import '../backend/Entities/Outlet.dart';
import '../backend/shortestPath.dart';

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
  GlobalKey stackKey = GlobalKey();
  List<Outlet> redPositions = [];
  List<Outlet> rangeIndexes =
      []; //temporary indexes, this one is according to the widget.center
  List<Beat> blueIndexes = [];

  //ALL THESE ARE FOR GREEN SLIDERS
  List<LatLng> pathPoints = [];
  bool isPathPointChoosing = false;
  List<Outlet> nearbyOutlets = []; // this is from the green slider

  changeColor(){
  }

  void refresh() {
    setState(() {});
  }

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
  void changeColor(Color newColor, int index) {
    setState(() {
      blueIndexes[index].color = newColor;
    });
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;

  void findOutletsInPolygon() {
    redPositions.addAll(nearbyOutlets);
    nearbyOutlets = [];
    List<int> removables = [];
    for (int z = 0; z < redPositions.length; z++) {
      var x = redPositions[z].lat, y = redPositions[z].lng;

      var inside = false;
      for (var i = 0, j = pathPoints.length - 1;
          i < pathPoints.length;
          j = i++) {
        var xi = pathPoints[i].latitude, yi = pathPoints[i].longitude;
        var xj = pathPoints[j].latitude, yj = pathPoints[j].longitude;

        var intersect = ((yi > y) != (yj > y)) &&
            (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
        if (intersect) inside = !inside;
      }
      if (inside) {
        nearbyOutlets.add(redPositions[z]);
        removables.add(z);
      }
    }

    for (var e in removables.reversed) {
      redPositions.removeAt(e);
    }

    setState(() {});
  }

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

  Widget _buildDraggableMarkerWidget(transformer, LatLng element, int i) {
    return DraggableMarker(transformer, true, Colors.green, element,
        (LatLng? latLng) {
      if (latLng != null) {
        pathPoints[i] = latLng;
        findOutletsInPolygon();
        setState(() {});
      }
    }, stackKey);
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
                isPathPointChoosing = !isPathPointChoosing;
              });
            },
          ),
          AddButtonIntent: CallbackAction(onInvoke: (intent) {
            showDialog(
                context: context,
                builder: (_) {
                  TextEditingController textController =
                      TextEditingController();
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
                            List<Widget> pathWidgets = [];
                            redPositions = widget.outletLatLng;
                            final markerWidgets = [];
                            if (widget.center != null) {
                              List<String> selectedOutlets = [];
                              for (Beat beat in blueIndexes) {
                                for (var element in beat.outlet) {
                                  selectedOutlets.add(element.id);
                                }
                              }

                              for (Beat beat in selectedDropDownItem.beats) {
                                for (var element in beat.outlet) {
                                  selectedOutlets.add(element.id);
                                }
                              }

                              redPositions = [];
                              rangeIndexes = [];
                              widget.outletLatLng
                                  .asMap()
                                  .entries
                                  .forEach((element) {
                                if (selectedOutlets
                                        .contains(element.value.beatID) ||
                                    widget.removePermPositions
                                        .contains(element.value)) {
                                  // bluePositions.add(element.value
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
                                          pos,
                                          blueIndexes[i].color ??
                                              Colors.blueGrey,
                                          false),
                                    ),
                              );
                            }
                            for (int i = 0; i < nearbyOutlets.length; i++) {
                              markerWidgets.addAll(
                                [
                                  LatLng(nearbyOutlets[i].lat,
                                      nearbyOutlets[i].lng)
                                ]
                                    .map(transformer.fromLatLngToXYCoords)
                                    .toList()
                                    .map(
                                      (pos) => _buildMarkerWidget(
                                          pos, Colors.blue, false),
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

                            for (int i = 0; i < pathPoints.length; i++) {
                              pathWidgets.add(
                                _buildDraggableMarkerWidget(
                                    transformer, pathPoints[i], i),
                              );
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
                                if (!isPathPointChoosing) {
                                  LatLng location =
                                      transformer.fromXYCoordsToLatLng(
                                          details.localPosition);

                                  Offset clicked = transformer
                                      .fromLatLngToXYCoords(location);
                                  if (!isPathPointChoosing) {
                                    widget.changeCenter(location);
                                  }
                                } else {
                                  LatLng location =
                                      transformer.fromXYCoordsToLatLng(Offset(
                                          details.localPosition.dx,
                                          details.localPosition.dy));
                                  if (widget.outletLatLng.isNotEmpty) {
                                    pathPoints.add(location);
                                    findOutletsInPolygon();
                                    setState(() {});
                                  } else {}
                                }
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
                                  key: stackKey,
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
                                    DragTarget(
                                      builder: (BuildContext context,
                                          List<Object?> candidateData,
                                          List<dynamic> rejectedData) {
                                        return CustomPaint(
                                          painter: ShapePainter(pathPoints
                                              .map(transformer
                                                  .fromLatLngToXYCoords)
                                              .toList()),
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
                                    ...pathWidgets,
                                    Positioned(
                                      bottom: 20,
                                      right: 20,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // isPathPointChoosing = !isPathPointChoosing;
                                            // removeCenter = null;
                                            // setRemoveRedRadius(0.0);
                                            isPathPointChoosing =
                                                !isPathPointChoosing;
                                          });
                                        },
                                        child: Focus(
                                          autofocus: true,
                                          child: Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                color: isPathPointChoosing
                                                    ? Colors.green
                                                    : Colors.red,
                                                shape: BoxShape.circle),
                                            child: const Icon(
                                              Icons.pattern_sharp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Positioned(
                                    //     top: 20,
                                    //     left: 20,
                                    //     child: Container(
                                    //       height: 50,
                                    //       width:300,
                                    //       color: Colors.white,
                                    //       child: TextField(
                                    //         decoration: InputDecoration(
                                    //           prefixIcon: Icon(Icons.search),
                                    //           hintText: " Outlet Name",
                                    //           border: OutlineInputBorder(),
                                    //
                                    //         ),
                                    //         onChanged: (text){
                                    //           SearchOutlets(widget.bluegreyIndexes);
                                    //         },
                                    //       ),
                                    //     ),),
                                    IconButton(
                                        onPressed: () {
                                          print(widget.bluegreyIndexes);
                                          showSearch(
                                            context: context,
                                            delegate: SearchOutlets(
                                                widget.outletLatLng),
                                          );
                                        },
                                        icon: Icon(Icons.search)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    isPathPointChoosing
                        ? GreenSlider(
                            () {
                              setState(() {
                                pathPoints = [];
                                nearbyOutlets = [];
                              });
                            },
                            nearbyOutlets,
                            redPositions,
                            rangeIndexes,
                            blueIndexes,
                            widget.setTempRedRadius,
                          )
                        : RedSlider(redPositions, widget.redDistance,
                            widget.setTempRedRadius, () {
                            setState(() {
                              rangeIndexes = [];
                              pathPoints = [];
                              widget.setTempRedRadius(0.0);
                              nearbyOutlets = [];
                            });
                          }),
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
                  updateBeat,
                  changeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
