import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'Entity/OutletsListEntity.dart';
import 'backend/Outlet.dart';

class NextScreen extends StatefulWidget {
  final Beat beat;

  NextScreen(this.beat);

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  List<Outlet> selectedOutlet = [];
  var size, height, width;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          Expanded(
            child: Builder(builder: (context) {
              size = MediaQuery.of(context).size;
              height = size.height;
              width = size.width;
              return GridView.builder(
                itemCount: widget.beat.outlet.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.125,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                padding: const EdgeInsets.all(12),
                itemBuilder: (_, i) {
                  return Container(
                    height: height / 4,
                    width: width / 4,
                    child: Stack(
                      children: [
                        Container(
                            height: height / 2,
                            width: width / 2,
                            child: Image.asset("assets/hilife.jpg")),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            // clipBehavior: Clip.hardEdge,
                            margin: const EdgeInsets.all(8),
                            width: 200,
                            height: 50,
                            child: DropdownSearch<String>(
                              showSearchBox: true,
                              mode: Mode.MENU,
                              items: const [
                                "Brazil",
                                "Italia (Disabled)",
                                "Tunisia",
                                'Canada'
                              ],
                              hint: "Select Distibutor",
                              popupItemDisabled: (String s) =>
                                  s.startsWith('I'),
                              onChanged: print,
                              selectedItem: "Brazil",
                              dropdownSearchDecoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Checkbox(
                            // activeColor: Colors.blue,
                            value:
                                selectedOutlet.contains(widget.beat.outlet[i]),
                            onChanged: (newValue) => setState(() {
                              if (selectedOutlet
                                  .contains(widget.beat.outlet[i])) {
                                selectedOutlet.remove(widget.beat.outlet[i]);
                              } else {
                                selectedOutlet.add(widget.beat.outlet[i]);
                              }
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            height: 50,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
