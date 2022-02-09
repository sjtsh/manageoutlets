import 'package:manage_outlets/Entity/OutletsListEntity.dart';

class Distributor {
  int? id;
  String distributorName;
  List<Beat> beats;

  Distributor(this.distributorName, this.beats, {this.id});

  @override
  String toString() {
    // TODO: implement toString
    return distributorName.toString();
  }
}
