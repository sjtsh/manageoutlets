import 'package:flutter/material.dart';
import 'package:manage_outlets/MapRelatedComponents/mapscreen.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';

class DraggableMarker extends StatefulWidget {
  final MapTransformer? localTransformer;
  final bool isLarge;
  final Color color;
  final LatLng latLng;
  final Function changeOffset;
  final GlobalKey stackKey;

  DraggableMarker(this.localTransformer, this.isLarge, this.color, this.latLng,
      this.changeOffset, this.stackKey);

  @override
  State<DraggableMarker> createState() => _DraggableMarkerState();
}

class _DraggableMarkerState extends State<DraggableMarker> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Offset? pos = widget.localTransformer?.fromLatLngToXYCoords(widget.latLng);
    double size = 15;
    return Positioned(
      left: pos?.dx ?? 0,
      top: pos?.dy ?? 0,

      width: widget.isLarge ? size : 24,
      height: widget.isLarge ? size : 24,
      child: Stack(
      clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -size/6,
            left: -size/6,
            child: Draggable(
               feedback: Image.asset("assets/draggable_marker.png", height: 16, width: 16,),
               // Container(
              //   height: size,
              //   width: size,
              //   decoration: const BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Colors.red,
              //
              //   ),
              // ),
               child: Image.asset("assets/draggable_marker.png", height: 16, width: 16,),
              // Container(
              //   height: size,
              //   width: size,
              //   decoration: const BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Colors.black,
              //   ),
              // ),
              onDragEnd: (dragDetails) {
                final parentPos = widget.stackKey.globalPaintBounds;
                if (parentPos == null) return;

                double _x = dragDetails.offset.dx - parentPos.left;
                double _y = dragDetails.offset.dy - parentPos.top;
                widget.changeOffset(widget.localTransformer
                    ?.fromXYCoordsToLatLng(Offset(_x, _y)));
              },
            ),
          )
        ],
      ),
    );
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return renderObject!.paintBounds
          .shift(Offset(translation.x -7.5, translation.y -7.5));
    } else {
      return null;
    }
  }
}
