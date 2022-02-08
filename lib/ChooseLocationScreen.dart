import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map/map.dart';

import 'package:latlng/latlng.dart';

import 'GetOutletScreen.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({Key? key}) : super(key: key);

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  LatLng? center;
  var controller;

  void _onDoubleTap() {
    controller?.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  final TextEditingController textController = TextEditingController();
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

  changeCenter(LatLng location) {
    setState(() {
      center = LatLng(location.latitude, location.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: FutureBuilder(
          future: Geolocator.getCurrentPosition(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Position position = snapshot.data;
              controller = MapController(
                location: LatLng(position.latitude, position.longitude),
              );
              return Column(
                children: [
                  Expanded(
                    child: MapLayoutBuilder(
                      controller: controller,
                      builder: (context, transformer) {
                        Widget? homeMarkerWidget;
                        if (center != null) {
                          final homeLocation =
                              transformer.fromLatLngToXYCoords(center!);

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
                              controller.zoom += 0.02;
                              setState(() {});
                            } else if (scaleDiff < 0) {
                              controller.zoom -= 0.02;
                              setState(() {});
                            } else {
                              final now = details.focalPoint;
                              final diff = now - _dragStart!;
                              _dragStart = now;
                              controller.drag(diff.dx, diff.dy);
                              setState(() {});
                            }
                          },
                          onTapUp: (details) {
                            LatLng location = transformer
                                .fromXYCoordsToLatLng(details.localPosition);
                            changeCenter(location);
                          },
                          child: Listener(
                            behavior: HitTestBehavior.opaque,
                            onPointerSignal: (event) {
                              if (event is PointerScrollEvent) {
                                final delta = event.scrollDelta;

                                controller.zoom -= delta.dy / 1000.0;
                                setState(() {});
                              }
                            },
                            child: Stack(
                              children: [
                                Map(
                                  controller: controller,
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 60,
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label:
                            Text("Enter the max distance for slider in double"),
                      ),
                      onChanged: (input) {
                        setState(() {});
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (textController.text != "" && center != null) {
                        try {
                          double.parse(textController.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) {
                              return GetOutletScreen(
                                  double.parse(textController.text), center!);
                            }),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter a parsable double"),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      color: (textController.text != "" && center != null)
                          ? Colors.green
                          : Colors.blueGrey,
                      child: const Center(
                          child: Text(
                        "DONE",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
