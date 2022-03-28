import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../MergeRelatedComponents/MergeScreen.dart';
import '../backend/Entities/Category.dart';
import '../backend/Entities/Outlet.dart';
import '../backend/Entities/OutletsListEntity.dart';

class ConfirmMergeDialogBox extends StatefulWidget {
  final List<Outlet> selectedOutlet;
  final List<Category> categories;
  final TextEditingController textController;
  final Outlet? chosenOutlet;
  final String? myID;
  final String? videoName;
  final String? categoryName;
  final String? beatID;
  final String? dateTime;
  final double? lat;
  final double? lng;
  final String? imageURL;
  final Beat tempBeat;
  final Function refresh;

  ConfirmMergeDialogBox(
      this.selectedOutlet,
      this.categories,
      this.textController,
      this.chosenOutlet,
      this.myID,
      this.videoName,
      this.categoryName,
      this.beatID,
      this.dateTime,
      this.lat,
      this.lng,
      this.imageURL,
      this.tempBeat, this.refresh);

  @override
  State<ConfirmMergeDialogBox> createState() => _ConfirmMergeDialogBoxState();
}

class _ConfirmMergeDialogBoxState extends State<ConfirmMergeDialogBox> {
  String? outletName;

  Category? category;

  int? categoryID;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          height: 300,
          width: 300,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "FILL THE REQUIREMENTS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: Container()),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.clear),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: widget.textController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Oulet Name (optional)"),
                ),
                const SizedBox(
                  height: 12,
                ),
                DropdownSearch(
                  showSearchBox: true,
                  items: List.generate(widget.selectedOutlet.length,
                      (index) => widget.selectedOutlet[index].outletName),
                  selectedItem: outletName,
                  hint: "Outlet Name",
                  onChanged: (String? input) {
                    setState(() {
                      outletName = input;
                    });
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                DropdownSearch(
                  selectedItem: category,
                  showSearchBox: false,
                  items: widget.categories,
                  hint: "Select Category",
                  onChanged: (Category? category) {
                    setState(() {
                      this.category = category;
                      categoryID = category?.id;
                    });
                  },
                ),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () {
                    if (widget.myID != null &&
                        widget.imageURL != null &&
                        widget.lat != null &&
                        widget.lng != null) {
                      if (widget.textController.text != "" ||
                          outletName != null) {
                        if (category != null) {
                          for (int i = 0;
                              i < widget.tempBeat.outlet.length;
                              i++) {
                            if (widget.tempBeat.outlet[i].id == widget.myID) {
                              widget.tempBeat.outlet[i].categoryName =
                                  (category!.categoryName);
                              widget.tempBeat.outlet[i].newcategoryID =
                                  categoryID;
                              widget.tempBeat.outlet[i].outletName =
                                  widget.textController.text == ""
                                      ? outletName!
                                      : widget.textController.text;
                              widget.tempBeat.outlet[i].lat = widget.lat!;
                              widget.tempBeat.outlet[i].lng = widget.lng!;
                              widget.tempBeat.outlet[i].imageURL =
                                  widget.imageURL!;
                              break;
                            }
                          }
                          List dynamicList = widget.selectedOutlet
                              .where((element) => element.id != widget.myID)
                              .toList();
                          for (var element in dynamicList) {
                            if (widget.tempBeat.deactivated == null) {
                              widget.tempBeat.deactivated = [element];
                            } else {
                              widget.tempBeat.deactivated?.add(element);
                            }
                            widget.tempBeat.outlet.remove(element);
                          }
                          Navigator.pop(context);
                          widget.refresh();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Successful")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Select a category")));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Select or enter the outlet name")));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Soemthing went wrong")));
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              color: Colors.black.withOpacity(0.1))
                        ]),
                    child: Center(
                      child: Text(
                        "CONFIRM",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
