import 'package:manage_outlets/Entity/OutletsListEntity.dart';

class Distributor {
  int? id;
  String distributorName;
  List<Beat> beats;
  List<Beat> insertableBeats;

  Distributor(this.distributorName, this.beats,
      {this.id, this.insertableBeats = const []});

  @override
  String toString() {
    // TODO: implement toString
    return distributorName.toString();
  }
}
