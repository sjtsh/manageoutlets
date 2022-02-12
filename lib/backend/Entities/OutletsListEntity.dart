import 'package:manage_outlets/backend/Entities/Outlet.dart';

class Beat {
  int? id;

  String beatName;
  List<Outlet> outlet;
  List<Outlet>? deactivated;

  Beat(this.beatName, this.outlet, {this.id, this.deactivated});

  factory Beat.fromJson(Map<String, dynamic> json) {
    return Beat(
      json["beatName"],
      [],
      id: int.parse(json["id"]),
    );
  }
}
