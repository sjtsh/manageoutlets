import 'dart:convert';

class Category {
  int id;
  String categoryName;

  Category(this.categoryName, this.id);

  @override
  String toString() {
    // TODO: implement toString
    return categoryName.toString();
  }


}
