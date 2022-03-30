import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hovering/hovering.dart';

import 'CompareInteractive.dart';
import '../OutletGridViewScreens/NextScreen.dart';
import '../DialogBox/backButtonAlert.dart';
import '../backend/Entities/Category.dart';
import '../backend/Entities/Outlet.dart';
import '../backend/Entities/OutletsListEntity.dart';
import '../backend/database.dart';

class SingularOutletNonMerging extends StatefulWidget {
  final List<Outlet> selectedOutlet;
  final Outlet tempOutlet;
  final TextEditingController controller;
  final Function changeOutletSelectionStatus;
  final bool isValidate;
  final List<Category> categories;
  final Function setCategoryID;
  final Beat tempBeat;
  final int i;
  final Function stopScroll;
  final Function setDeactivated;

  SingularOutletNonMerging(
      this.selectedOutlet,
      this.tempOutlet,
      this.controller,
      this.changeOutletSelectionStatus,
      this.isValidate,
      this.categories,
      this.setCategoryID,
      this.tempBeat,
      this.i,
      this.stopScroll,
      this.setDeactivated);

  @override
  State<SingularOutletNonMerging> createState() =>
      _SingularOutletNonMergingState();
}

class _SingularOutletNonMergingState extends State<SingularOutletNonMerging> {
  int numberOfTurns = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: widget.selectedOutlet.contains(widget.tempOutlet)
                ? Colors.green
                : Colors.transparent,
            width: widget.selectedOutlet.contains(widget.tempOutlet) ? 5 : 0,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 2),
                spreadRadius: 2,
                blurRadius: 2,
                color: Colors.black.withOpacity(0.1))
          ],
        ),
        child: GestureDetector(
          onTap: () {
            widget.changeOutletSelectionStatus(widget.tempOutlet);
          },
          child: Stack(
            children: [
              Column(children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    Checkbox(
                        activeColor: Colors.green,
                        value:
                            widget.selectedOutlet.contains(widget.tempOutlet),
                        onChanged: (newValue) => widget
                            .changeOutletSelectionStatus(widget.tempOutlet)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          color: Colors.white,
                          child: TextField(
                            autofocus: true,
                            controller: widget.controller,
                            onChanged: (String? text) {
                              widget.tempOutlet.outletName = text ?? "";
                            },
                            decoration: InputDecoration(
                              errorText: (widget.controller.text == "" &&
                                      !widget.isValidate)
                                  ? 'Field Can\'t Be Empty'
                                  : null,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Text(tempOutlet.outletName),
                    // Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        height: 50,
                        child: Builder(builder: (context) {
                          print(widget.tempOutlet.newcategoryID);
                          return DropdownSearch<Category>(
                            showSearchBox: false,
                            mode: Mode.MENU,
                            dropdownButtonSplashRadius: 1,
                            dropDownButton: SizedBox.shrink(),
                            items: widget.categories,
                            onChanged: (Category? category) {
                              widget.setCategoryID(category, widget.i);
                            },
                            dropdownBuilder:
                                (BuildContext context, Category? category) {
                              return Text(
                                category?.categoryName ?? "",
                                style: TextStyle(fontSize: 12),
                              );
                            },
                            selectedItem: (widget.tempOutlet.newcategoryID ==
                                    null)
                                ? (widget.tempBeat.status! > 1
                                    ? widget.categories.firstWhere((e) =>
                                        e.id == widget.tempOutlet.categoryID)
                                    : Category("Select category", 10000000))
                                : widget.categories.firstWhere((e) =>
                                    e.id == widget.tempOutlet.newcategoryID!),
                            dropdownSearchDecoration: InputDecoration(
                                errorText:
                                    (widget.tempOutlet.newcategoryID == null &&
                                            !widget.isValidate)
                                        ? "define category"
                                        : null,
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                border: OutlineInputBorder()),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return BackButtonAlert(
                                  "Do you want to deactivate this outlet?",
                                  "REMOVE",
                                  "CANCEL", () {
                                widget.setDeactivated(
                                    widget.tempOutlet.id, true);
                              });
                            });
                      },
                      child: const Icon(
                        Icons.clear,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: numberOfTurns,
                          child: Container(
                            color: Colors.black.withOpacity(0.1),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onHover: (PointerHoverEvent a) {
                                widget.stopScroll(false);
                                // await Future.delayed(Duration(seconds: 5));
                                // widget.stopScroll(true);
                              },
                              onExit: (PointerExitEvent a) {
                                widget.stopScroll(true);
                              },
                              child: InteractiveViewer(
                                maxScale: 1000,
                                child: CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl: widget.tempBeat.outlet[widget.i]
                                              .videoName ==
                                          null
                                      ? widget
                                          .tempBeat.outlet[widget.i].imageURL
                                      : localhost +
                                          widget.tempBeat.outlet[widget.i]
                                              .imageURL,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              Positioned(
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      color: widget.tempOutlet.videoName == null
                          ? Colors.red
                          : Colors.green,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1))
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.tempOutlet.videoName == null ? "FA" : "SC",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        numberOfTurns++;
                      });
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1))
                        ],
                      ),
                      child: Center(
                        child: Icon(Icons.rotate_90_degrees_ccw_sharp),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
