import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../backend/Entities/Category.dart';
import '../backend/Entities/OutletsListEntity.dart';
import '../backend/database.dart';

class InteractiveImage extends StatefulWidget {
  final List selectedOutlet;
  final Beat tempBeat;
  final int i;
  final TextEditingController controller;
  final List<Category> categories;
  final bool isValidate;

  InteractiveImage(this.selectedOutlet, this.tempBeat, this.i, this.controller,
      this.categories, this.isValidate);

  @override
  State<InteractiveImage> createState() => _InteractiveImageState();
}

class _InteractiveImageState extends State<InteractiveImage> {
  int rotated = 0;

  void rotate(int newRotation) {
    print(newRotation);
    setState(() {
      rotated = newRotation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            height: 50,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      rotated ++;
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1))
                      ],
                    ),
                    child: Center(
                      child:
                      Icon(Icons.rotate_90_degrees_ccw_sharp),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: InteractiveViewer(
              // boundaryMargin:
              //     const EdgeInsets.all(20.0),
              minScale: 0.7,
              maxScale: 3.1,
              child: Builder(
                  builder: (context) {
                    return RotatedBox(
                      quarterTurns: rotated,
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                        child: Image.network(
                          widget.tempBeat.outlet[widget.i]
                              .videoName ==
                              null
                              ? widget.tempBeat.outlet[widget.i]
                              .imageURL
                              : localhost +
                              widget.tempBeat.outlet[widget.i]
                                  .imageURL,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }
              ),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.only(
              right: 24,
              left: 24,
              top: 6,
            ),
            color: Colors.green,
            child: Row(
              children: [
                Expanded(child: Container()),
                Container(
                  height: 60,
                  width: 300,
                  child: TextField(
                    controller: widget.controller,
                    decoration: const InputDecoration(
                        contentPadding:
                        const EdgeInsets.fromLTRB(8, 0, 0, 8),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Container(
                  width: 300,
                  height: 60,
                  child: Builder(builder: (context) {
                    return DropdownSearch<Category>(
                      showSearchBox: true,
                      mode: Mode.MENU,
                      items: widget.categories,
                      onChanged: (selected) {
                        setState(() {
                          widget.tempBeat.outlet[widget.i]
                              .newcategoryID = selected?.id;
                        });
                      },
                      selectedItem: ((widget.tempBeat as Beat)
                          .outlet[widget.i]
                          .newcategoryID ==
                          null)
                          ? Category("Select category", 10000000)
                          : widget.categories.firstWhere((e) =>
                      e.id ==
                          (widget.tempBeat)
                              .outlet[widget.i]
                              .newcategoryID),
                      dropdownSearchDecoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          errorText: (widget
                              .tempBeat
                              .outlet[widget.i]
                              .newcategoryID ==
                              null &&
                              widget.isValidate)
                              ? "define category"
                              : null,
                          contentPadding:
                          const EdgeInsets.fromLTRB(
                              8, 0, 0, 8),
                          border: OutlineInputBorder()),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
