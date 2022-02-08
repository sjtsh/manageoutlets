class Distributor {
  int id;
  String distributorName;

  Distributor(this.distributorName, this.id);

  factory Distributor.fromJson(Map<String, dynamic> json) {
    return Distributor(json["distributorName"], int.parse(json["id"]));
  }
}
