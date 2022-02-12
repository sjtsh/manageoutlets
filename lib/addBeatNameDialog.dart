import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'backend/Entities/Outlet.dart';
import 'backend/Entities/OutletsListEntity.dart';
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

  toBeatList(rangeIndexes, blueIndexes, textController, setTempRedRadius,
      redPositions, context, validate) {
    if (textController.text == "") {
      validate = true;
    } else {
      validate = false;
    }

    if (validate == false) {
      rangeIndexes = [];
      print(redPositions.length);
      blueIndexes.add(
        Beat(textController.text, shortestPath(redPositions)),
      );
      setTempRedRadius(0.0);
      Navigator.pop(context);
    }
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
                  context,
                  validate);
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
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.clear),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Expanded(
                      child: Focus(
                        autofocus: true,
                        child: TextField(
                          controller: widget.textController,
                          decoration: InputDecoration(
                            errorText: validate == true
                                ? 'Field Can\'t Be Empty'
                                : null,
                            border: const OutlineInputBorder(),
                            label: const Text("beat name"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Focus(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                            BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  color: Colors.black
                                      .withOpacity(0.1))
                            ]),
                        child: Material(
                          color: Colors.green,
                          child: InkWell(
                            onTap: (){
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
                                    context,
                                    validate);
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
