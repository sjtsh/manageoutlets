import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manage_outlets/backend/database.dart';

import '../backend/Entities/Distributor.dart';
import '../backend/Entities/Outlet.dart';
import '../backend/Entities/OutletsListEntity.dart';
import '../backend/Entities/User.dart';
import '../backend/Services/UserService.dart';
import '../backend/shortestPath.dart';

class UpdateBeatDialogBox extends StatefulWidget {
  final List<Outlet> rangeIndexes;
  final List<Beat> blueIndexes;
  final List<Outlet> redPositions;
  final Function refresh;
  final Function addBeat;
  final List<Beat> beats;
  final Distributor selectedDropdownItem;

  UpdateBeatDialogBox(this.rangeIndexes, this.blueIndexes, this.redPositions,
      this.refresh, this.addBeat, this.beats, this.selectedDropdownItem);

  @override
  State<UpdateBeatDialogBox> createState() => _UpdateBeatDialogBoxState();
}

class AddtoBeatIntent extends Intent {}

class _UpdateBeatDialogBoxState extends State<UpdateBeatDialogBox> {
  bool validate = false;
  bool isDisabled = false;
  Beat? selected;

  Future<void> toBeatList(rangeIndexes, blueIndexes, List<Outlet> redPositions,
      context, validate, Function refresh) async {
    try {
      if (selected == null) {
        validate = true;
      } else {
        validate = false;
      }

      if (validate == false) {
        if (redPositions.isNotEmpty) {
          rangeIndexes = [];
          await widget.addBeat(
            // Beat(textController.text, shortestPath(redPositions),
            //     color: colorIndex[widget.blueIndexes.length]),
            // Beat(textController.text, redPositions,
            //     color: colorIndex[widget.blueIndexes.length],
            //     userID: selected!.id,
            //     status: 1),
            // widget.selectedDropdownItem.id,
          );
          // setTempRedRadius(0.0);
          refresh();
          Navigator.pop(context);
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {LogicalKeySet(LogicalKeyboardKey.enter): AddtoBeatIntent()},
      child: Actions(
        actions: {
          AddtoBeatIntent: CallbackAction(onInvoke: (intent) async {
            setState(() {
              if (selected == null) {
                validate = true;
              } else {
                validate = false;
              }
            });

            if (validate == false) {
              isDisabled = true;
              setState(() {});
              await toBeatList(widget.rangeIndexes, widget.blueIndexes,
                  widget.redPositions, context, validate, widget.refresh);
              isDisabled = false;
              setState(() {});
            }
          }),
        },
        child: Center(
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: 300,
                height: 159,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "UPDATE BEAT",
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
                    Container(
                      height: 70,
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownSearch(
                          showSearchBox: true,
                          selectedItem: selected,
                          onChanged: (Beat? c) {
                            if (c != null) {
                              selected = c;
                              setState(() {
                                validate = false;
                              });
                            }
                          },
                          itemAsString: (Beat? beat) {
                            if (beat == null) {
                              return "Select Beat";
                            }
                            return beat.beatName;
                          },
                          items: widget.beats,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Focus(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
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
                        child: Material(
                          color: Colors.blue,
                          child: isDisabled
                              ? InkWell(
                                  onTap: () async {},
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () async {
                                    setState(() {
                                      if (selected == null) {
                                        validate = true;
                                      } else if (selected == null) {
                                        validate = true;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Select a assignable"),
                                          ),
                                        );
                                      } else {
                                        validate = false;
                                      }
                                    });

                                    if (validate == false) {
                                      isDisabled = true;
                                      setState(() {});
                                      await toBeatList(
                                          widget.rangeIndexes,
                                          widget.blueIndexes,
                                          widget.redPositions,
                                          context,
                                          validate,
                                          widget.refresh);
                                      isDisabled = false;
                                      setState(() {});
                                    }
                                  },
                                  child: const Center(
                                    child: Text(
                                      "UPDATE",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
