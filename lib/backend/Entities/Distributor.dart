import 'package:manage_outlets/backend/Entities/OutletsListEntity.dart';

class Distributor {
  int id;
  String distributorName;
  List<Beat> beats;
  List<Beat> insertableBeats;

  Distributor(this.id, this.distributorName, this.beats,
      {this.insertableBeats = const []});

  @override
  String toString() {
    // TODO: implement toString
    return distributorName.toString();
  }
}
