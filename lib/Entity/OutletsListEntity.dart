import 'package:manage_outlets/backend/Entities/Outlet.dart';

class Beat {
  int? id;

  String beatName;
  List<Outlet> outlet;

  Beat(this.beatName, this.outlet, {this.id});
}
