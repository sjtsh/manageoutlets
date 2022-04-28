import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:manage_outlets/DraggableMarker.dart';
import 'package:manage_outlets/MapRelatedComponents/SearchOutlets.dart';
import 'package:manage_outlets/MapRelatedComponents/SingularBeat/AssignedBeat.dart';
import 'package:manage_outlets/ShapePainteer.dart';
import 'package:manage_outlets/Sliders/BlueSlider.dart';
import 'package:manage_outlets/Sliders/GreenSlider.dart';
import 'package:manage_outlets/Sliders/RedSlider.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:manage_outlets/backend/Services/BeatService.dart';
import 'package:manage_outlets/backend/database.dart';
import 'package:manage_outlets/DialogBox/addBeatNameDialog.dart';
import 'package:map/map.dart';
import '../BeforeMapScreens/LocalHostScreen.dart';
import '../backend/Entities/OutletsListEntity.dart';
import '../backend/Entities/PathPoint.dart';
import '../backend/Entities/User.dart';
import '../backend/Services/DistributorService.dart';
import '../backend/Services/UserService.dart';
import 'DetailedMapScreenRightPanel.dart';
import 'MapScreenRightPanel.dart';
import '../backend/Entities/Distributor.dart';
import '../backend/Entities/Outlet.dart';
import '../backend/shortestPath.dart';
import 'SingularBeat/BeatWidgets.dart';
import 'SingularBeat/ReviewBeat.dart';
import 'SingularBeat/SyncButton.dart';

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
  final bool isDeactivated;
  final Function changeDeactivated;
  final Function setDeactivated;
  final Function addDistributor;

  final List<User> users;
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
    this.isDeactivated,
    this.changeDeactivated,
    this.setDeactivated,
    this.users,
    this.addDistributor,
  );

  @override
  _MapScreenState createState() => _MapScreenState();
}

class MinusButtonIntent extends Intent {}

class AIntent extends Intent {}

class AddButtonIntent extends Intent {}

class switchSelection extends Intent {}

class _MapScreenState extends State<MapScreen> {
  GlobalKey stackKey = GlobalKey();
  List<Outlet> redPositions = [];
  List<Outlet> rangeIndexes =
      []; //temporary indexes, this one is according to the widget.center
  List<Beat> blueIndexes = [];
  List<Outlet> nonDeactivatedOutlets = [];

  //ALL THESE ARE FOR GREEN SLIDERS
  List<LatLng> pathPoints = [];
  List<Outlet> nearbyOutlets = []; // this is from the green slider

  int isPathPointChoosing =
      1; //false initially, 1 for populate, 2 for add, 3 for populate

  List<Outlet> updatableOutlets = []; //for the blue slider

  double totalDistance = 0;

  int maxRedDistance = 2000;
  MapTransformer? localTransformer;

  void refresh() {
    setState(() {});
  }

  Distributor selectedDropDownItem =
      Distributor(-1, "Select Distributor", [], []);

  Offset? _dragStart;
  double _scaleStart = 1.0;

  void findOutletsInUpdatablePolygon() {
    updatableOutlets = [];
    List<int> removables = [];
    for (int z = 0; z < nonDeactivatedOutlets.length; z++) {
      var x = nonDeactivatedOutlets[z].lat, y = nonDeactivatedOutlets[z].lng;

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
        updatableOutlets.add(nonDeactivatedOutlets[z]);
        removables.add(z);
      }
    }
    for (var e in removables.reversed) {
      nonDeactivatedOutlets.removeAt(e);
    }
    List a = shortestPath(updatableOutlets);
    updatableOutlets = a[0];
    totalDistance = a[1] + 0.0;
    setState(() {});
  }

  void findOutletsInPolygon() {
    // if (pathPoints.isEmpty) setState(() => totalDistance = 0);
    List<String> selectedOutlets = [];
    for (Beat beat in blueIndexes) {
      for (var element in beat.outlet) {
        selectedOutlets.add(element.id);
      }
    }

    redPositions.addAll(nearbyOutlets
        .where((element) => !selectedOutlets.contains(element.id)));
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
    List a = shortestPath(nearbyOutlets);
    nearbyOutlets = a[0];
    totalDistance = a[1] + 0.0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.numpadSubtract): MinusButtonIntent(),
        LogicalKeySet(LogicalKeyboardKey.numpadAdd): AddButtonIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.f1):
            AIntent(),
        LogicalKeySet(LogicalKeyboardKey.shiftLeft): switchSelection(),
      },
      actions: {
        MinusButtonIntent: CallbackAction(
          onInvoke: (intent) {
            setState(() {
              if (isPathPointChoosing == 3) {
                isPathPointChoosing = 1;
              } else if (isPathPointChoosing == 2) {
                isPathPointChoosing = 3;
              } else {
                isPathPointChoosing = 2;
              }
            });
          },
        ),
        AddButtonIntent: CallbackAction(onInvoke: (intent) {
          // showDialog(
          //     context: context,
          //     builder: (_) {
          //       TextEditingController textController =
          //       TextEditingController();
          //       return AddBeatDialogBox(
          //           textController,
          //           rangeIndexes,
          //           blueIndexes,
          //           redPositions,
          //           refresh,
          //           addBeat,
          //           widget.users,
          //           selectedDropDownItem);
          //     })
        }),
        AIntent: CallbackAction(onInvoke: (intent) {
          showDialog(
              context: context,
              builder: (_) {
                TextEditingController controller = TextEditingController();
                return Center(
                  child: Container(
                    height: 150,
                    width: 300,
                    child: Material(
                      color: Color(0xfff2f2f2),
                      child: Container(
                        clipBehavior: Clip.none,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              controller: controller,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  try {
                                    widget.setTempRedRadius(0.0);
                                    maxRedDistance = int.parse(controller.text);
                                  } catch (e) {
                                    print("cant parse");
                                  }
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                color: Colors.green,
                                height: 60,
                                child: Center(
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        }),
        switchSelection: CallbackAction(onInvoke: (intent) {
          setState(() {
            // isPathPointChoosing = !isPathPointChoosing;
            // removeCenter = null;
            // setRemoveRedRadius(0.0);
            setState(() {
              if (isPathPointChoosing == 3) {
                isPathPointChoosing = 1;
              } else if (isPathPointChoosing == 2) {
                isPathPointChoosing = 3;
              } else {
                isPathPointChoosing = 2;
              }
            });
          });
        })
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        body: Builder(builder: (context) {
          Size size = MediaQuery.of(context).size;
          return Stack(
            children: [
              Row(
                children: [
                  Container(
                    height: size.height,
                    width: size.width * 3 / 4 - 20,
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
                              builder: (context, MapTransformer transformer) {
                                localTransformer = transformer;
                                List<Widget> pathWidgets = [];
                                List<Outlet> outletsDone = [];
                                redPositions = widget.outletLatLng;
                                final markerWidgets = [];
                                List<Widget> toBeAdded = [];
                                if (widget.center != null) {
                                  List<String> selectedOutlets = [];
                                  for (Beat beat in blueIndexes) {
                                    for (var element in beat.outlet) {
                                      selectedOutlets.add(element.id);
                                    }
                                  }
                                  for (Distributor distributor
                                      in widget.distributors) {
                                    for (Beat beat in distributor.beats) {
                                      for (Outlet outlet in beat.outlet) {
                                        outletsDone.add(outlet);
                                      }
                                    }
                                  }
                                  for (Beat beat
                                      in selectedDropDownItem.beats) {
                                    for (var element in beat.outlet) {
                                      selectedOutlets.add(element.id);
                                    }
                                  }
                                  redPositions = [];
                                  rangeIndexes = [];
                                  nonDeactivatedOutlets = [];
                                  [...widget.outletLatLng, ...outletsDone]
                                      .asMap()
                                      .entries
                                      .forEach((element) {
                                    if (element.value.deactivated) {
                                      if (widget.isDeactivated &&
                                          GeolocatorPlatform.instance
                                                  .distanceBetween(
                                                      element.value.lat,
                                                      element.value.lng,
                                                      widget.center!.latitude,
                                                      widget
                                                          .center!.longitude) <
                                              widget.redDistance) {
                                        markerWidgets.addAll([
                                          LatLng(element.value.lat,
                                              element.value.lng)
                                        ]
                                            .map(transformer
                                                .fromLatLngToXYCoords)
                                            .toList()
                                            .map((pos) =>
                                                // _buildMarkerWidget(
                                                // pos, Colors.brown, false),
                                                _buildMarkerWidgetAddedDisabled(
                                                    pos,
                                                    "assets/disabled_marker.png",
                                                    false)));
                                      }
                                    } else {
                                      if (GeolocatorPlatform.instance
                                              .distanceBetween(
                                                  element.value.lat,
                                                  element.value.lng,
                                                  widget.center!.latitude,
                                                  widget.center!.longitude) <
                                          widget.redDistance) {
                                        nonDeactivatedOutlets
                                            .add(element.value);
                                      }
                                      bool doesUpdatableOutletsContains = false;
                                      for (var outlet in updatableOutlets) {
                                        if (outlet.id == element.value.id) {
                                          doesUpdatableOutletsContains = true;
                                          break;
                                        }
                                      }
                                      if (doesUpdatableOutletsContains &&
                                          isPathPointChoosing == 3) {
                                        toBeAdded.addAll(
                                          [
                                            LatLng(element.value.lat,
                                                element.value.lng)
                                          ]
                                              .map(transformer
                                                  .fromLatLngToXYCoords)
                                              .toList()
                                              .map(
                                                (pos) => _buildMarkerWidget(
                                                    pos, Colors.blue, false),
                                              ),
                                        );
                                      } else if (selectedOutlets
                                              .contains(element.value.id) ||
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
                                        if (element.value.beatID != null) {
                                          markerWidgets.addAll([
                                            LatLng(element.value.lat,
                                                element.value.lng)
                                          ]
                                              .map(transformer
                                                  .fromLatLngToXYCoords)
                                              .toList()
                                              .map(
                                                (pos) =>
                                                    _buildMarkerWidgetAddedDisabled(
                                                        pos,
                                                        "assets/done_marker_1.png",
                                                        false),
                                              ));
                                        } else if (nearbyOutlets
                                                .contains(element.value) &&
                                            isPathPointChoosing == 2) {
                                          toBeAdded.addAll(
                                            [
                                              LatLng(element.value.lat,
                                                  element.value.lng)
                                            ]
                                                .map(transformer
                                                    .fromLatLngToXYCoords)
                                                .toList()
                                                .map(
                                                  (pos) => _buildMarkerWidget(
                                                      pos, Colors.blue, false),
                                                ),
                                          );
                                        } else {
                                          redPositions.add(element.value);
                                          markerWidgets.addAll([
                                            LatLng(element.value.lat,
                                                element.value.lng)
                                          ]
                                              .map(transformer
                                                  .fromLatLngToXYCoords)
                                              .toList()
                                              .map(
                                                (pos) => _buildMarkerWidget(
                                                    pos, Colors.red, false),
                                              ));
                                        }
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

                                Widget? homeMarkerWidget;
                                Widget? removeMarkerWidget;
                                if (widget.center != null) {
                                  final homeLocation = transformer
                                      .fromLatLngToXYCoords(widget.center!);

                                  homeMarkerWidget = _buildMarkerWidget(
                                      homeLocation, Colors.black, true);
                                }
                                for (int i = 0;
                                    i < selectedDropDownItem.beats.length;
                                    i++) {
                                  List<Outlet> outlets = [];
                                  for (var element
                                      in selectedDropDownItem.beats[i].outlet) {
                                    bool doesUpdatableOutletsContains = false;
                                    for (var outlet in updatableOutlets) {
                                      if (outlet.id == element.id) {
                                        doesUpdatableOutletsContains = true;
                                        break;
                                      }
                                    }
                                    if (!doesUpdatableOutletsContains) {
                                      outlets.add(element);
                                    }
                                  }
                                  markerWidgets.addAll(
                                    List.generate(
                                            outlets.length,
                                            (e) => LatLng(
                                                outlets[e].lat, outlets[e].lng))
                                        .map(transformer.fromLatLngToXYCoords)
                                        .toList()
                                        .map(
                                          (pos) => _buildMarkerWidget(
                                              pos,
                                              selectedDropDownItem
                                                      .beats[i].color ??
                                                  Colors.blueGrey,
                                              false),
                                        ),
                                  );
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
                                    final scaleDiff =
                                        details.scale - _scaleStart;
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
                                    if (isPathPointChoosing == 1) {
                                      LatLng location =
                                          transformer.fromXYCoordsToLatLng(
                                              details.localPosition);
                                      if (isPathPointChoosing == 1) {
                                        widget.changeCenter(location);
                                      }
                                    } else {
                                      LatLng location = transformer
                                          .fromXYCoordsToLatLng(Offset(
                                              details.localPosition.dx,
                                              details.localPosition.dy));
                                      if (isPathPointChoosing == 2) {
                                        if (widget.outletLatLng.isNotEmpty) {
                                          pathPoints.add(location);
                                          findOutletsInPolygon();
                                          setState(() {});
                                        }
                                      }

                                      if (isPathPointChoosing == 3) {
                                          pathPoints.add(location);
                                          findOutletsInUpdatablePolygon();
                                          setState(() {});
                                        }
                                    }
                                  },
                                  child: Listener(
                                    behavior: HitTestBehavior.opaque,
                                    onPointerSignal: (event) {
                                      if (event is PointerScrollEvent) {
                                        final delta = event.scrollDelta;
                                        widget.controller.zoom -=
                                            delta.dy / 50.0;
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
                                                'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sTerrain!4e0!5m1!1e0!23i4111425';
                                            // final url = 'https://www.google.com/maps/vt/pb=!1m5!1m4!1i$z!2i$x!3i$y!4i128!2m2!1e0!3i597327680!3m7!2sen!3snp!5e1105!12m1!1e47!12m1!1e3!4e0!5m1!1e0!23i10204745';
                                            // "https://www.google.com/maps/vt/staticmap?size=330x230&markers=size:tiny|color:green|31.80501,35.233979999999974&markers=size:tiny|color:red|31.80452,35.23406&visible=31.80501,35.233979999999974,31.80452,35.23406&path=color:0x0000ff|weight:3|31.805010000000003,35.23398|31.80487,35.23378|31.804790000000004,35.233740000000004|31.804740000000002,35.233740000000004|31.804690000000004,35.233760000000004|31.804630000000003,35.2338|31.804570000000002,35.233920000000005|31.804520000000004,35.23406&sensor=false";
                                            return CachedNetworkImage(
                                              imageUrl: url,
                                              fit: BoxFit.cover,
                                            );
                                            return Image.network(url);
                                          },
                                        ),
                                        CustomPaint(
                                          painter: FilledShapePainter(
                                              selectedDropDownItem.boundary
                                                  .map(transformer
                                                      .fromLatLngToXYCoords)
                                                  .toList()),
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
                                        ...toBeAdded,
                                        Positioned(
                                          bottom: 20,
                                          left: 20,
                                          child: Container(
                                            height: 50,
                                            width: 200,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Center(
                                              child: DropdownButton(
                                                value: isPathPointChoosing,
                                                items: const [1, 2, 3]
                                                    .map((e) =>
                                                        DropdownMenuItem(
                                                          child: Text(
                                                              itemAsString(e)
                                                                  .toString()),
                                                          value: e,
                                                        ))
                                                    .toList(),
                                                onChanged: (int? i) {
                                                  if (i != null) {
                                                    setState(() {
                                                      isPathPointChoosing = i;
                                                    });
                                                  }
                                                },
                                                underline: Container(),
                                                iconEnabledColor: Colors.white,
                                                dropdownColor: Colors.green,
                                                style: TextStyle(
                                                    color: Colors.white),
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
                        isPathPointChoosing == 1
                            ? Builder(builder: (context) {
                                return RedSlider(
                                    redPositions,
                                    widget.redDistance,
                                    widget.setTempRedRadius, () {
                                  setState(() {
                                    rangeIndexes = [];
                                    pathPoints = [];
                                    widget.setTempRedRadius(0.0);
                                    nearbyOutlets = [];
                                  });
                                }, maxRedDistance);
                              })
                            : isPathPointChoosing == 2
                                ? Builder(builder: (context) {
                                    if (pathPoints.isEmpty) totalDistance = 0;
                                    return GreenSlider(
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
                                        refresh,
                                        () {
                                          setState(() {
                                            totalDistance = 0.0;
                                            pathPoints = [];
                                            nearbyOutlets = [];
                                          });
                                        },
                                        addBeat,
                                        totalDistance,
                                        widget.users,
                                        selectedDropDownItem);
                                  })
                                : Builder(builder: (context) {
                                    if (pathPoints.isEmpty) totalDistance = 0;
                                    List<Beat> beats = [];
                                    for (var element in widget.distributors) {
                                      beats.addAll(element.beats);
                                    }
                                    return BlueSlider(
                                        () {
                                          setState(() {
                                            pathPoints = [];
                                            updatableOutlets = [];
                                          });
                                        },
                                        updatableOutlets,
                                        redPositions,
                                        rangeIndexes,
                                        blueIndexes,
                                        widget.setTempRedRadius,
                                        refresh,
                                        () {
                                          setState(() {
                                            totalDistance = 0.0;
                                            pathPoints = [];
                                            updatableOutlets = [];
                                          });
                                        },
                                        addBeat,
                                        totalDistance,
                                        widget.users,
                                        selectedDropDownItem,
                                        beats,
                                        updateOutletsToNewBeat);
                                  }),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height,
                    width: size.width * 1 / 4,
                  ),
                ],
              ),
              SizedBox(
                height: size.height,
                width: size.width,
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    Builder(builder: (context) {
                      List<Beat> beats = selectedDropDownItem.beats
                          .where((element) => element.status == 2)
                          .toList();
                      List<Beat> beats2 = selectedDropDownItem.beats
                          .where((element) => element.status == 1)
                          .toList();
                      List<Widget> listOfBeatWidgets = [
                        ...List.generate(
                          beats.length,
                          (int index) {
                            return ReviewBeat(
                                beats[index],
                                changeColor,
                                index,
                                renameBeat,
                                widget.categories,
                                refresh,
                                widget.users,
                                selectedDropDownItem,
                                setNewBeats,
                                widget.distributors);
                          },
                        )
                      ];
                      List<Widget> listOfBeatWidgets2 = [
                        ...List.generate(
                          beats2.length,
                          (int index) {
                            return AssignedBeat(
                                beats2[index],
                                changeColor,
                                index,
                                renameBeat,
                                widget.users,
                                widget.distributors,
                                selectedDropDownItem,
                                setNewBeats);
                          },
                        ),
                        ...List.generate(
                          beats.length,
                          (int index) {
                            return ReviewBeat(
                                beats[index],
                                changeColor,
                                index,
                                renameBeat,
                                widget.categories,
                                refresh,
                                widget.users,
                                selectedDropDownItem,
                                setNewBeats,
                                widget.distributors);
                          },
                        )
                      ];

                      Widget sync = SyncButton(selectedDropDownItem,
                          _changeDropDownValue, setNewBeats);
                      return ExpandablePanel(
                        collapsed: SizedBox(
                          height: size.height,
                          width: size.width * 1 / 4 + 20,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              ExpandableButton(
                                child: Container(
                                    height: 100,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      border: Border.all(
                                          color: Colors.black.withOpacity(0.5)),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        size: 16,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: MapScreenRightPanel(
                                  widget.categories,
                                  widget.distributors,
                                  blueIndexes,
                                  selectedDropDownItem,
                                  _changeDropDownValue,
                                  refresh,
                                  changeColor,
                                  widget.isDeactivated,
                                  widget.changeDeactivated,
                                  renameBeat,
                                  widget.users,
                                  listOfBeatWidgets2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        expanded: SizedBox(
                          height: size.height,
                          width: size.width * 0.5,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              Builder(builder: (context) {
                                return ExpandableButton(
                                  child: Container(
                                    height: 100,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      border: Border.all(
                                          color: Colors.black.withOpacity(0.5)),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              Expanded(
                                child: DetailedMapScreenRightPanel(
                                    widget.categories,
                                    widget.distributors,
                                    blueIndexes,
                                    selectedDropDownItem,
                                    _changeDropDownValue,
                                    refresh,
                                    changeColor,
                                    widget.isDeactivated,
                                    widget.changeDeactivated,
                                    renameBeat,
                                    widget.users,
                                    listOfBeatWidgets,
                                    sync,
                                    widget.addDistributor,
                                    setNewBeats),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void _changeDropDownValue(Distributor newValue) {
    setState(() {
      selectedDropDownItem = newValue;
      for (int i = 0; i < selectedDropDownItem.beats.length; i++) {
        selectedDropDownItem.beats[i].color = colorIndex[
            (selectedDropDownItem.beats[i].id ?? 3) % (colorIndex.length - 1)];
      }
      if (localTransformer != null) {
        if (selectedDropDownItem.boundary.isNotEmpty) {
          widget.controller.center = selectedDropDownItem.boundary[0];
        } else if (selectedDropDownItem.beats.isNotEmpty) {
          Outlet outlet = selectedDropDownItem.beats
              .firstWhere((element) => element.outlet.isNotEmpty)
              .outlet[0];
          widget.controller.center = LatLng(outlet.lat, outlet.lng);
        }
      }
    });
  }

  Future<bool> renameBeat(Beat beat,
      {Distributor? distributor, String? newBeatName}) async {
    if (distributor == null) {
      bool success = await DistributorService().updateDistributor(
          beat, selectedDropDownItem, newBeatName ?? beat.beatName);
      if (success) {
        Beat name =
            selectedDropDownItem.beats.firstWhere((item) => item.id == beat.id);
        setState(() => name.beatName = newBeatName ?? beat.beatName);
        return success;
      } else {
        return success;
      }
    } else {
      bool success = await DistributorService()
          .updateDistributor(beat, distributor, newBeatName ?? beat.beatName);
      if (success) {
        Beat name =
            selectedDropDownItem.beats.firstWhere((item) => item.id == beat.id);
        selectedDropDownItem.beats.removeWhere((element) => element == name);
        name.beatName = newBeatName ?? beat.beatName;
        widget.distributors
            .firstWhere((element) => element.id == distributor.id)
            .beats
            .add(name);
        setState(() {});
        return success;
      } else {
        return success;
      }
    }
  }

  void _onDoubleTap() {
    widget.controller.zoom += 0.5;
    setState(() {});
  }

  void changeColor(
    Color newColor,
    Beat index,
  ) {
    setState(() {
      selectedDropDownItem.beats
          .firstWhere((element) => element == index)
          .color = newColor;
    });
  }

  setNewBeats(
    List<Beat> beats,
    int distributorID,
  ) {
    Distributor distributor = widget.distributors
        .firstWhere((element) => element.id == distributorID);
    distributor.beats = beats;
    selectedDropDownItem.beats = beats;
    _changeDropDownValue(distributor);
    setState(() {});
  }

  Future<void> addBeat(
    Beat newBeat,
    Distributor distributor,
  ) async {
    await UserService().assignOutlets(
        [newBeat], distributor, context, setNewBeats).then((value) {
      if (value) {
        setState(() {
          isPathPointChoosing = 1;
          pathPoints = [];
          nearbyOutlets = [];
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Try Again")));
      }
    });
  }

  Future<void> updateOutletsToNewBeat(
    List<Outlet> outlets,
    int beatID,
  ) async {
    await BeatService()
        .updateOutletToStatus2(outlets, beatID, context)
        .then((value) {
      if (value) {
        setState(() {
          isPathPointChoosing = 1;
          pathPoints = [];
          nearbyOutlets = [];
        });
        Navigator.push(context, MaterialPageRoute(builder: (_){
          return LocalHostScreen();
        }));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Try Again")));
      }
    });
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

  Widget _buildMarkerWidgetAddedDisabled(
      Offset pos, String imgName, bool isLarge) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: isLarge ? 50 : 24,
      height: isLarge ? 50 : 24,
      child: Image.asset(
        imgName,
        height: 24,
        width: 24,
      ),
    );
  }

  Widget _buildDraggableMarkerWidget(transformer, LatLng element, int i) {
    return DraggableMarker(transformer, true, Colors.green, element,
        (LatLng? latLng) {
      if (latLng != null) {
        pathPoints[i] = latLng;
        if (isPathPointChoosing == 2) {
          findOutletsInPolygon();
        }

        if (isPathPointChoosing == 3) {
          findOutletsInUpdatablePolygon();
        }
        setState(() {});
      }
    }, stackKey);
  }
}
