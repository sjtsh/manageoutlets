import 'package:flutter/material.dart';

import '../backend/Entities/Outlet.dart';

class SearchOutlets extends SearchDelegate<String> {
  final List<Outlet> outlets;

  SearchOutlets(this.outlets);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () {
      query= "";
    }, icon: Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () {
      Navigator.pop(context);
    }, icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Outlet> suggestion = outlets.where((outletname) {
      return outletname.outletName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    return ListView.builder(
        itemCount: suggestion.length,
        itemBuilder: (_, index) {
          return Container(
            child: Text(suggestion[index].outletName),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Outlet> suggestion = outlets.where((outletname) {
      return outletname.outletName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    return ListView.builder(
        itemCount: suggestion.length,
        itemBuilder: (_, index) {
          return Text(suggestion[index].outletName);
        });
  }
}
