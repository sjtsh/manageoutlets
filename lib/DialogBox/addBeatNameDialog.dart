import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manage_outlets/backend/database.dart';

import '../backend/Entities/Distributor.dart';
import '../backend/Entities/Outlet.dart';
import '../backend/Entities/OutletsListEntity.dart';
import '../backend/Entities/User.dart';
import '../backend/Services/UserService.dart';
import '../backend/shortestPath.dart';

class AddBeatDialogBox extends StatefulWidget {
  final TextEditingController textController;
  final List<Outlet> rangeIndexes;
  final List<Beat> blueIndexes;
  final List<Outlet> redPositions;
  final Function refresh;
  final Function addBeat;
  final List<User> users;
  final Distributor selectedDropdownItem;

  AddBeatDialogBox(
      this.textController,
      this.rangeIndexes,
      this.blueIndexes,
      this.redPositions,
      this.refresh,
      this.addBeat,
      this.users,
      this.selectedDropdownItem);

  @override
  State<AddBeatDialogBox> createState() => _AddBeatDialogBoxState();
}

class AddtoBeatIntent extends Intent {}

class _AddBeatDialogBoxState extends State<AddBeatDialogBox> {
  bool validate = false;
  User? selected;

  toBeatList(rangeIndexes, blueIndexes, textController,
      List<Outlet> redPositions, context, validate, Function refresh) {
    if (textController.text == "") {
      validate = true;
    } else {
      validate = false;
    }

    if (validate == false) {
      if (redPositions.isNotEmpty) {
        rangeIndexes = [];
        widget.addBeat(
          // Beat(textController.text, shortestPath(redPositions),
          //     color: colorIndex[widget.blueIndexes.length]),
          Beat(textController.text, redPositions,
              color: colorIndex[widget.blueIndexes.length],
              userID: selected!.id,
              status: 1),
          widget.selectedDropdownItem.id,
        );
        // setTempRedRadius(0.0);
        refresh();
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {LogicalKeySet(LogicalKeyboardKey.enter): AddtoBeatIntent()},
      child: Actions(
        actions: {
          AddtoBeatIntent: CallbackAction(onInvoke: (intent) {
            setState(() {
              if (widget.textController.text == "") {
                validate = true;
              } else {
                validate = false;
              }
            });

            if (validate == false) {
              toBeatList(
                  widget.rangeIndexes,
                  widget.blueIndexes,
                  widget.textController,
                  widget.redPositions,
                  context,
                  validate,
                  widget.refresh);
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
                height: 230,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "ADD BEAT NAME",
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
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: widget.textController,
                        decoration: InputDecoration(
                          errorText:
                              validate == true ? 'Field Can\'t Be Empty' : null,
                          border: const OutlineInputBorder(),
                          label: const Text("Beat name"),
                        ),
                        onChanged: (value){
                          setState(() {
                            validate = false;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 300,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          isExpanded: true,
                          hint: Text("Select user"),
                          underline: Text(''),
                          onChanged: (User? c) {
                            if (c != null) {
                              selected = c;
                              setState(() {});
                            }
                          },
                          items: List.generate(
                            widget.users.length,
                            (e) => DropdownMenuItem(
                              child: Text(widget.users[e].name),
                              value: widget.users[e],
                            ),
                          ),
                          value: selected,
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
                          color: Colors.green,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.textController.text == "") {
                                  validate = true;
                                } else if (selected == null) {
                                  validate = true;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Select a assignable"),
                                    ),
                                  );
                                } else {
                                  validate = false;
                                }
                              });

                              if (validate == false) {
                                toBeatList(
                                    widget.rangeIndexes,
                                    widget.blueIndexes,
                                    widget.textController,
                                    widget.redPositions,
                                    context,
                                    validate,
                                    widget.refresh);
                              }
                            },
                            child: const Center(
                              child: Text(
                                "ENTER",
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
