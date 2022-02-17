import 'package:latlng/latlng.dart';

import 'Outlet.dart';

class PathPoint {
  final LatLng latLng;
  List<Outlet>? sortedOutlet;

  PathPoint({required this.latLng, this.sortedOutlet});
}
