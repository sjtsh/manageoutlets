import 'package:manage_outlets/backend/Entities/OutletsListEntity.dart';
import 'package:latlng/latlng.dart';

class Distributor {
  int id;
  String distributorName;
  List<Beat> beats;
  List<Beat> insertableBeats;
  List<LatLng> boundary;

  Distributor(this.id, this.distributorName, this.beats, this.boundary,
      {this.insertableBeats = const [], });

  @override
  String toString() {
    // TODO: implement toString
    return distributorName.toString();
  }
}
