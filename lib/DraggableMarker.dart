import 'package:flutter/material.dart';
import 'package:manage_outlets/MapRelatedComponents/mapscreen.dart';
import 'package:map/map.dart';

class DraggableMarker extends StatefulWidget {
  final MapTransformer? localTransformer;
  final bool isLarge;
  final Color color;
  final Offset offset;
  final Function changeCenter;
  final GlobalKey stackKey;

  DraggableMarker(this.localTransformer, this.isLarge, this.color, this.offset,
      this.changeCenter, this.stackKey);

  @override
  State<DraggableMarker> createState() => _DraggableMarkerState();
}

class _DraggableMarkerState extends State<DraggableMarker> {
  late Offset pos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pos = widget.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(

      left: pos.dx - 16,
      top: pos.dy - 16,
      width: widget.isLarge ? 50 : 24,
      height: widget.isLarge ? 50 : 24,
      child: Draggable(
        feedback: Icon(
          Icons.location_on,
          color: widget.color,
          size: 30,
        ),
        child: Icon(
          Icons.location_on,
          color: widget.color,
          size: 30,
        ),
        onDragEnd: (dragDetails) {
          // 10.
          setState(() {
            final parentPos = widget.stackKey.globalPaintBounds;
            if (parentPos == null) return;

            double _x = dragDetails.offset.dx - parentPos.left; // 11.
            double _y = dragDetails.offset.dy - parentPos.top;
            pos = Offset(_x, _y);
            widget.changeCenter(
                widget.localTransformer?.fromXYCoordsToLatLng(Offset(_x, _y)));
          });
        },
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
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}