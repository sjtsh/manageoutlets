import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:manage_outlets/backend/Entities/Category.dart';
import 'package:manage_outlets/backend/database.dart';

import 'Entity/OutletsListEntity.dart';
import 'backend/Entities/Outlet.dart';

class NextScreen extends StatefulWidget {
  final Beat beat;
  final List<Category> categories;

  NextScreen(this.beat, this.categories);

  @override
  State<NextScreen> createState() => _NextScreenState();
}

Category selectedCategories = Category("Select category", 10000000);

void _changeDropDownValue(Category newValue) {
  selectedCategories = newValue;
}


class _NextScreenState extends State<NextScreen> {
  List<Outlet> selectedOutlet = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: Center(
              child: Text(
                "Select Photo for ${widget.beat.beatName} Beat",
                style: TextStyle(color: Colors.black),
              ),
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            toolbarHeight: 50,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              double height = MediaQuery
                  .of(context)
                  .size
                  .height;
              double width = MediaQuery
                  .of(context)
                  .size
                  .width;
              return GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2,
                children: List.generate(widget.beat.outlet.length, (i) {
                  print(" hello categories ${widget.categories}");
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: height / 2 - 24,
                      width: width / 2 - 24,
                      child: Stack(
                        children: [
                          Builder(
                              builder: (context) {
                                print(localhost + "/" +
                                    widget.beat.outlet[i].imageURL);
                                return Container(
                                  height: height / 2 - 24,
                                  width: width / 2 - 24,
                                  child: Image.network(
                                    localhost + widget.beat.outlet[i].imageURL,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              // clipBehavior: Clip.hardEdge,
                              margin: const EdgeInsets.all(8),
                              width: 200,
                              height: 50,
                              child: Builder(
                                builder: (context) {
                                  print(" hello categories dropdown ${widget.categories}");
                                  return DropdownSearch<Category>(
                                    showSearchBox: true,
                                    mode: Mode.MENU,
                                    items: widget.categories,
                                    onChanged: (selected) {
                                      _changeDropDownValue(selectedCategories);
                                    },
                                    selectedItem: selectedCategories,
                                    dropdownSearchDecoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: InputBorder.none,
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Checkbox(
                              // activeColor: Colors.blue,
                              value: selectedOutlet
                                  .contains(widget.beat.outlet[i]),
                              onChanged: (newValue) =>
                                  setState(() {
                                    if (selectedOutlet
                                        .contains(widget.beat.outlet[i])) {
                                      selectedOutlet.remove(
                                          widget.beat.outlet[i]);
                                    } else {
                                      selectedOutlet.add(widget.beat.outlet[i]);
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
          Container(
            height: 120,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
