class OutletCategory {
  int id;
  String categoryName;

  OutletCategory(this.categoryName, this.id);

  factory OutletCategory.fromJson(Map<String, dynamic> json){
  return OutletCategory(
      json["categoryName"],
    int.parse(json["id"]));

  }



}