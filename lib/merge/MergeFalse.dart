import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:manage_outlets/Entity/OutletsListEntity.dart';

import '../ImageNew.dart';
import '../backend/Outlet.dart';

class MergeFalse extends StatefulWidget {
  final List<Beat> beat1;
  final Function setMerge;
  final List<Outlet> outlets;
  final List flexMap;
  final List<int> selected;
  final int? toBeMergedTo;
  final Function select;

  final TextEditingController beatController;
  final TextEditingController distributorController;

  MergeFalse(
      this.beat1,
      this.setMerge,
      this.outlets,
      this.flexMap,
      this.selected,
      this.toBeMergedTo,
      this.beatController,
      this.distributorController, this.select);

  @override
  State<MergeFalse> createState() => _MergeFalseState();
}

class _MergeFalseState extends State<MergeFalse> {
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
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: widget.beatController,
                    decoration: InputDecoration(labelText: "Beat Name"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: widget.distributorController,
                    decoration: InputDecoration(labelText: "Distributor Name"),
                  ),
                )),
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
                  flex: widget.flexMap[3],
                  child: Center(
                    child: Text("CSV Path"),
                  ),
                ),
                Expanded(
                  flex: widget.flexMap[4],
                  child: Center(
                    child: Text("Directory / Cloud"),
                  ),
                ),
                Expanded(
                  flex: widget.flexMap[5],
                  child: Center(
                    child: Text("Image"),
                  ),
                ),
                Expanded(
                  flex: widget.flexMap[6],
                  child: Center(
                    child: Text("Selected"),
                  ),
                ),
                Expanded(
                  flex: widget.flexMap[7],
                  child: Center(
                    child: Text("Remove"),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.outlets.length,
                itemBuilder: (context, int index) {
                  TextEditingController controller = TextEditingController(
                      text: widget.outlets[index].outletName);
                  return (widget.selected.contains(index))
                      ? Padding(
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
                                    child: Text(
                                        widget.outlets[index].id.toString()),
                                  ),
                                ),
                                Expanded(
                                  flex: widget.flexMap[1],
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: TextField(
                                      controller: controller,
                                      onChanged: (String? input) {
                                        widget.outlets[index].outletName =
                                            input.toString();
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: widget.flexMap[2],
                                  child: Center(
                                    child: Text(widget.outlets[index].lat
                                            .toString() +
                                        "," +
                                        widget.outlets[index].lng.toString()),
                                  ),
                                ),
                                Expanded(
                                  flex: widget.flexMap[3],
                                  child: Center(
                                    child: Text(
                                      widget.outlets[index].videoName == null
                                          ? "FA"
                                          : "OWN",
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: widget.flexMap[4],
                                  child: Center(
                                    child: Text(
                                        widget.outlets[index].videoName == null
                                            ? "FA"
                                            : "OWN"),
                                  ),
                                ),
                                Expanded(
                                  flex: widget.flexMap[5],
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return ImageNew(widget.outlets, index,
                                            widget.selected, widget.select);
                                      }));
                                    },
                                    child: Image.network(
                                        widget.outlets[index].imageURL),
                                  ),
                                ),
                                Expanded(
                                  flex: widget.flexMap[6],
                                  child: Center(
                                    child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            widget.select(index);
                                          },
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: widget.selected
                                                      .contains(index)
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                            child: Center(
                                              child: widget.selected
                                                      .contains(index)
                                                  ? Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                    )
                                                  : Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                                Expanded(
                                  flex: widget.flexMap[7],
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.outlets.removeAt(index);
                                      });
                                    },
                                    child: Center(
                                      child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.red)),
                                          child: Center(
                                              child: Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                          ))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container();
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (widget.selected.isNotEmpty) {
                        widget.setMerge(true);
                      }
                    },
                    child: Container(
                      height: 60,
                      color: widget.selected.isEmpty
                          ? Colors.blueGrey
                          : Colors.green,
                      child: const Center(
                        child: Text(
                          "MERGE",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (widget.beatController.text != "" &&
                          widget.distributorController.text != "") {
                        String? directoryPath = await FilePicker.platform
                            .getDirectoryPath(dialogTitle: "Where to store?");
                        String contents =
                            "id,outletName,image path,latitude,longitude,csv path,image storage,beat,distributor\n";
                        if (directoryPath != null) {
                          for (var element in widget.outlets) {
                            contents += element.id.toString().trim() +
                                "," +
                                element.outletName.trim() +
                                "," +
                                element.imageURL.trim() +
                                "," +
                                element.lat.toString().trim() +
                                "," +
                                element.lng.toString().trim() +
                                "," +
                                widget.beatController.text.trim() +
                                "," +
                                widget.distributorController.text.trim() +
                                "\n";
                          }
                          File(directoryPath +
                                  "\\${widget.distributorController.text.trim()}_${widget.beatController.text.trim()}.csv")
                              .writeAsString(contents)
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Saved at $directoryPath\\${widget.distributorController.text.trim()}_${widget.beatController.text.trim()}.csv")));
                          });
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      color: Colors.yellow,
                      child: const Center(
                        child: Text(
                          "EXPORT",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
