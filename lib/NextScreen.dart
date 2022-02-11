import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:manage_outlets/MergeMap.dart';
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
          Row(
            children: [
              Expanded(
                child: AppBar(
                  title: Center(
                    child: Text(
                      "Select Photo for ${widget.beat.beatName} Beat",
                      style: const TextStyle(color: Colors.black),
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
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.arrow_forward_outlined,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 12,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Builder(builder: (context) {
                double height = MediaQuery.of(context).size.height;
                double width = MediaQuery.of(context).size.width;
                return GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: width / (height * 1.175),
                  children: List.generate(widget.beat.outlet.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedOutlet.contains(widget.beat.outlet[i])
                              ? Colors.blue
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, -2),
                                spreadRadius: 2,
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.1))
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 12,
                                ),
                                Checkbox(
                                  // activeColor: Colors.blue,
                                  value: selectedOutlet
                                      .contains(widget.beat.outlet[i]),
                                  onChanged: (newValue) => setState(() {
                                    if (selectedOutlet
                                        .contains(widget.beat.outlet[i])) {
                                      selectedOutlet
                                          .remove(widget.beat.outlet[i]);
                                    } else {
                                      selectedOutlet.add(widget.beat.outlet[i]);
                                    }
                                  }),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text("Outlet Name"),
                                Expanded(child: Container()),
                                Container(
                                  width: 200,
                                  child: Builder(builder: (context) {
                                    return DropdownSearch<Category>(
                                      showSearchBox: true,
                                      mode: Mode.MENU,
                                      items: widget.categories,
                                      onChanged: (selected) {
                                        _changeDropDownValue(
                                            selectedCategories);
                                      },
                                      selectedItem: selectedCategories,
                                      dropdownSearchDecoration:
                                          const InputDecoration(
                                        // filled: true,
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF01689A),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.clear,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.black.withOpacity(0.1),
                                child: Image.network(
                                  widget.beat.outlet[i].videoName == null
                                      ? widget.beat.outlet[i].imageURL
                                      : localhost +
                                          widget.beat.outlet[i].imageURL,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
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
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, -2),
                    spreadRadius: 2,
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.1))
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: selectedOutlet
                        .map(
                          (e) => Stack(
                            children: [
                              Container(
                                width: 200,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, -2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.1),
                                    )
                                  ],
                                ),
                                child: Image.network(
                                  e.videoName == null
                                      ? e.imageURL
                                      : localhost + e.imageURL,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  selectedOutlet.remove(e);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.clear),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
                Container(
                  width: 500,
                  child: MergeMap(widget.beat.outlet, selectedOutlet, false),
                ),
                GestureDetector(
                  onTap: () {
                    // WindowUtils.
                  },
                  child: Container(
                    color: selectedOutlet.length > 1
                        ? Colors.green
                        : Colors.blueGrey,
                    width: 100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "MERGE",
                            style: TextStyle(color: Colors.white),
                          ),
                          const Icon(
                            Icons.arrow_forward_outlined,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
