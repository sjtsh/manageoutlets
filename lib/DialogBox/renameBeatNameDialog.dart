import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manage_outlets/backend/database.dart';

import '../backend/Entities/Outlet.dart';
import '../backend/Entities/OutletsListEntity.dart';
import '../backend/shortestPath.dart';

class RenameBeatNameDialog extends StatefulWidget {
final String oldBeatName;
final Function renameBeat;

  RenameBeatNameDialog(this.oldBeatName, this.renameBeat);


  @override
  State<RenameBeatNameDialog> createState() => _RenameBeatNameDialogState();
}


class _RenameBeatNameDialogState extends State<RenameBeatNameDialog> {
  bool validate = false;
  TextEditingController textEditingController = TextEditingController();


  // toBeatList(rangeIndexes, blueIndexes, textController,
  //     List<Outlet> redPositions, context, validate, Function refresh) {
  //   if (textController.text == "") {
  //     validate = true;
  //   } else {
  //     validate = false;
  //   }
  //
  //   if (validate == false) {
  //     if(redPositions.isNotEmpty){
  //       rangeIndexes = [];
  //       widget.addBeat(
  //         Beat(textController.text, shortestPath(redPositions),
  //             color: colorIndex[widget.blueIndexes.length]),
  //       );
  //       // setTempRedRadius(0.0);
  //       refresh();
  //       Navigator.pop(context);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    textEditingController.text = widget.oldBeatName;
    return Shortcuts(
      shortcuts: {LogicalKeySet(LogicalKeyboardKey.enter): RenameBeat()},
      child: Actions(
        actions: {
        RenameBeat: CallbackAction(onInvoke: (intent) {
          if (textEditingController.text == "") {
            validate = true;
            print(validate.toString() + " on level 1");
          } else {
            validate = false;
          }


          if (validate == false) {
            widget.renameBeat(widget.oldBeatName, textEditingController.text);
            Navigator.pop(context);

          }

      })
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
                          "RENAME BEAT NAME",
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
                        controller: textEditingController,
                        decoration: InputDecoration(
                          errorText: validate == true
                              ? 'Field Can\'t Be Empty'
                              : null,
                          border: const OutlineInputBorder(),
                          label: const Text("Beat name"),
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

                                if (textEditingController.text == "") {
                                  validate = true;
                                  print(validate.toString() + " on level 1");
                                } else {
                                  validate = false;
                                }


                              if (validate == false) {
                                widget.renameBeat(widget.oldBeatName, textEditingController.text);
                                Navigator.pop(context);

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

class RenameBeat extends Intent {
}
