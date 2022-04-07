import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';

class ShapePainter extends CustomPainter {
  final List<Offset> pathOffsets;

  ShapePainter(this.pathOffsets);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.addPolygon(pathOffsets, true);
    // canvas.drawPath(path, paint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class FilledShapePainter extends CustomPainter {
  final List<Offset> pathOffsets;

  FilledShapePainter(this.pathOffsets);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.addPolygon(pathOffsets, true);
    // canvas.drawPath(path, paint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}