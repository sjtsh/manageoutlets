import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manage_outlets/backend/database.dart';

import '../backend/Entities/Distributor.dart';
import '../backend/Entities/Outlet.dart';
import '../backend/Entities/OutletsListEntity.dart';
import '../backend/shortestPath.dart';

class RenameBeatNameDialog extends StatefulWidget {
  final Beat beat;
  final Function renameBeat;
  final List<Distributor> distributors;

  RenameBeatNameDialog(this.beat, this.renameBeat, this.distributors);

  @override
  State<RenameBeatNameDialog> createState() => _RenameBeatNameDialogState();
}

class _RenameBeatNameDialogState extends State<RenameBeatNameDialog> {
  bool validate = false;
  TextEditingController textEditingController = TextEditingController();
  Distributor? selectedDropDownItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController.text = widget.beat.beatName;
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {LogicalKeySet(LogicalKeyboardKey.enter): RenameBeat()},
      child: Actions(
        actions: {
          RenameBeat: CallbackAction(
            onInvoke: (intent) async {
              if (textEditingController.text == "") {
                validate = true;
                print(validate.toString() + " on level 1");
              } else {
                validate = false;
              }

              if (validate == false) {
                // Future<bool> renameBeat(Beat beat,
                //     {Distributor? distributor, String? newBeatName})
                bool success = await widget.renameBeat(widget.beat,
                    distributor: selectedDropDownItem,
                    newBeatName: textEditingController.text == ""
                        ? null
                        : textEditingController.text);
                if (success) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Unsuccessful")));
                }
              }
            },
          ),
        },
        child: Center(
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 200,
                width: 400,
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
                          errorText:
                              validate == true ? 'Field Can\'t Be Empty' : null,
                          border: const OutlineInputBorder(),
                          label: const Text("Beat name"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white,
                      child: DropdownSearch<Distributor>(
                        showSearchBox: true,
                        mode: Mode.MENU,
                        items: widget.distributors,
                        onChanged: (selected) {
                          setState(() {
                            selectedDropDownItem = selected as Distributor;
                          });
                        },
                        selectedItem: selectedDropDownItem,
                        popupItemBuilder: (BuildContext context,
                            Distributor distributor, bool a) {
                          return Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(distributor.distributorName),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              distributor.beats.isNotEmpty
                                  ? Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 12),
                                    child: Text(
                                      distributor.beats.length
                                          .toString() +
                                          " beats",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                                  : Container(),
                            ],
                          );
                        },
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
                            onTap: () async {
                              if (textEditingController.text == "") {
                                validate = true;
                                print(validate.toString() + " on level 1");
                              } else {
                                validate = false;
                              }

                              if (validate == false) {
                                // Future<bool> renameBeat(Beat beat,
                                //     {Distributor? distributor, String? newBeatName})
                                bool success = await widget.renameBeat(widget.beat,
                                    distributor: selectedDropDownItem,
                                    newBeatName: textEditingController.text == ""
                                        ? null
                                        : textEditingController.text);
                                if (success) {
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text("Unsuccessful")));
                                }
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

class RenameBeat extends Intent {}
