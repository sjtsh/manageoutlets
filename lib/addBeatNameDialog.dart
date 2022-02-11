import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Entity/OutletsListEntity.dart';
import 'backend/Entities/Outlet.dart';
import 'backend/shortestPath.dart';

class AddBeatDialogBox extends StatefulWidget {
  final TextEditingController textController;
  final List<Outlet> rangeIndexes;
  final List<Beat> blueIndexes;
  final List<Outlet> redPositions;
  final Function setTempRedRadius;

  AddBeatDialogBox(this.textController, this.rangeIndexes, this.blueIndexes,
      this.redPositions, this.setTempRedRadius);

  @override
  State<AddBeatDialogBox> createState() => _AddBeatDialogBoxState();
}

class AddtoBeatIntent extends Intent {}

class _AddBeatDialogBoxState extends State<AddBeatDialogBox> {
  bool validate = false;

  void toBeatList(
    rangeIndexes,
    blueIndexes,
    textController,
    setTempRedRadius,
    redPositions,
    context,
  ) {
    rangeIndexes = [];

    blueIndexes.add(
      Beat(textController.text, shortestPath(redPositions)),
    );
    setTempRedRadius(0.0);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {LogicalKeySet(LogicalKeyboardKey.enter): AddtoBeatIntent()},
      child: Actions(
        actions: {
          AddtoBeatIntent: CallbackAction(onInvoke: (intent) {
            print("Added");

            setState(() {
              if (widget.textController.text == "") {
                validate = true;
                print(validate.toString() + " on level 1");
              } else {
                validate = false;
              }
            });

            if (validate == false) {
              toBeatList(
                  widget.rangeIndexes,
                  widget.blueIndexes,
                  widget.textController,
                  widget.setTempRedRadius,
                  widget.redPositions,
                  context);
            }
          }),
        },
        child: Center(
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 150,
                width: 300,
                child: Row(
                  children: [
                    Expanded(
                      child: Focus(
                        autofocus: true,
                        child: TextField(
                          controller: widget.textController,
                          decoration: InputDecoration(
                            errorText: validate == true
                                ? 'Field Can\'t Be Empty'
                                : null,
                            border: const OutlineInputBorder( ),
                            label: const Text("beat name"),
                          ),
                        ),
                      ),
                    ),
                    Focus(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (widget.textController.text == "") {
                              validate = true;
                              print(validate.toString() + " on level 1");
                            } else {
                              validate = false;
                            }
                          });

                          if (validate == false) {
                            toBeatList(
                                widget.rangeIndexes,
                                widget.blueIndexes,
                                widget.textController,
                                widget.setTempRedRadius,
                                widget.redPositions,
                                context);
                          }
                        },
                        color: Colors.blue,
                        icon: Icon(
                          Icons.send,
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
