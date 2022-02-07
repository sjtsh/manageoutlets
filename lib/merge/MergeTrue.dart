import 'package:flutter/material.dart';

import '../backend/Outlet.dart';

class MergeTrue extends StatefulWidget {
  final List<Outlet> outlets1;
  final Function setMerge;
  final List<Outlet> outlets;
  final List flexMap;
  final List<int> selected;
  final int? toBeMergedTo;
  final Function confirmMerge;

  MergeTrue(
    this.outlets1,
    this.setMerge,
    this.outlets,
    this.flexMap,
    this.selected,
    this.toBeMergedTo,
    this.confirmMerge,
  );

  @override
  State<MergeTrue> createState() => _MergeTrueState();
}

class _MergeTrueState extends State<MergeTrue> {
  String stringid = "0";
  String mergableID = "0";
  String mergableName = "0";
  String mergableLat = "0";
  String mergableLng = "0";
  String mergableImg = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: Expanded(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_rounded)),
                Expanded(
                  child: Container(
                    height: 60,
                    child: const Center(child: Text("MERGE MULTIPLE OUTLETS")),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 2),
                        spreadRadius: 3,
                        blurRadius: 3),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: widget.flexMap[0],
                      child: Center(
                        child: Text(widget.toBeMergedTo.toString()),
                      ),
                    ),
                    Expanded(
                      flex: widget.flexMap[1],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: DropdownButton(
                          onChanged: (input) {
                            setState(() {
                              mergableName = input.toString();
                            });
                          },
                          items: List.generate(widget.selected.length,
                                  (e) => widget.outlets[widget.selected[e]])
                              .map((e) => DropdownMenuItem(
                                    child: Text(e.outletName.toString()),
                                    value: e.id,
                                  ))
                              .toList(),
                          value: mergableName,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: widget.flexMap[2],
                      child: Center(
                        child: DropdownButton(
                          onChanged: (input) {
                            setState(() {
                              mergableLat = input.toString();
                              mergableLng = input.toString();
                              stringid = mergableLat;
                            });
                          },
                          items: List.generate(widget.selected.length,
                                  (e) => widget.outlets[widget.selected[e]])
                              .map((e) => DropdownMenuItem(
                                    child: Text(e.lat.toString() +
                                        ", " +
                                        e.lng.toString()),
                                    value: e.id,
                                  ))
                              .toList(),
                          value: mergableLat,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: widget.flexMap[5],
                      child: Center(
                        child: DropdownButton(
                          onChanged: (input) {
                            setState(() {
                              mergableImg = input.toString();
                            });
                          },
                          items: List.generate(widget.selected.length,
                                  (e) => widget.outlets[widget.selected[e]])
                              .map((e) => DropdownMenuItem(
                                    child: Image.network(e.imageURL),
                                    value: e.id,
                                  ))
                              .toList(),
                          value: mergableImg,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Divider(
              color: Colors.black,
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  flex: widget.flexMap[0],
                  child: Center(
                    child: Text("ID"),
                  ),
                ),
                Expanded(
                  flex: widget.flexMap[1],
                  child: Center(
                    child: Text("Name"),
                  ),
                ),
                Expanded(
                  flex: widget.flexMap[2],
                  child: Center(
                    child: Text("Lat, Lng"),
                  ),
                ),
                Expanded(
                  flex: widget.flexMap[5],
                  child: Center(
                    child: Text("Image"),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.setMerge(false);
                    },
                    child: Container(
                      color: Colors.red,
                      height: 60,
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.confirmMerge();
                    },
                    child: Container(
                      color: widget.toBeMergedTo == null
                          ? Colors.blueGrey
                          : Colors.green,
                      height: 60,
                      child: Center(
                        child: Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
