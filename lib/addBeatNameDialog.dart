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

  const AddBeatDialogBox(this.textController, this.rangeIndexes, this.blueIndexes,
      this.redPositions, this.setTempRedRadius);

  @override
  State<AddBeatDialogBox> createState() => _AddBeatDialogBoxState();
}

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

class AddtoBeatIntent extends Intent {}

class _AddBeatDialogBoxState extends State<AddBeatDialogBox> {
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {LogicalKeySet(LogicalKeyboardKey.enter): AddtoBeatIntent()},
      child: Actions(
        actions: {
          AddtoBeatIntent: CallbackAction(onInvoke: (intent) {
            print("Added");
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
                      child: TextField(
                        controller: widget.textController,
                        decoration: InputDecoration(
                          errorText: _validate == true
                              ? 'Field Can\'t Be Empty'
                              : null,
                          label: Text("beat name"),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // setState(() {
                        //   if (widget.textController
                        //       .text ==
                        //       "") {
                        //     _validate = true;
                        //     print(_validate.toString() + " on level 1");
                        //   } else {
                        //     _validate = false;
                        //   }
                        // });
                        //
                        // if (_validate ==
                        //     false) {
                        toBeatList(
                            widget.rangeIndexes,
                            widget.blueIndexes,
                            widget.textController,
                            widget.setTempRedRadius,
                            widget.redPositions,
                            context,
                            _validate);
                        // widget.rangeIndexes = [];
                        //
                        //   widget.blueIndexes.add(
                        //     Beat(
                        //         widget.textController
                        //             .text,
                        //         shortestPath(
                        //             widget.redPositions)),
                        //   );
                        //   widget
                        //       .setTempRedRadius(
                        //       0.0);
                        //   Navigator.pop(
                        //       context);
                        // }
                      },
                      color: Colors.blue,
                      icon: Icon(
                        Icons.send,
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
