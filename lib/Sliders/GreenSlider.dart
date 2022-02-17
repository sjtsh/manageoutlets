import 'package:flutter/material.dart';

import '../DialogBox/addBeatNameDialog.dart';
import '../backend/Entities/Outlet.dart';
import '../backend/Entities/OutletsListEntity.dart';

class GreenSlider extends StatelessWidget {
  final List<Outlet> focusedOutlets;
  final List<Outlet> visibleOutlets;
  final Function clearFunction;
  final List<Outlet> rangeIndexes;
  final List<Beat> blueIndexes;
  final Function setTempRedRadius;

  GreenSlider(this.clearFunction, this.focusedOutlets, this.visibleOutlets, this.rangeIndexes, this.blueIndexes, this.setTempRedRadius);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12, left: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 2),
              spreadRadius: 2,
              blurRadius: 2,
              color: Colors.black.withOpacity(0.1))
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            "${focusedOutlets.length.toString()} outlets in $visibleOutlets selected",
            style: const TextStyle(fontSize: 20),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.1))
                      ]),
                  child: RawMaterialButton(
                    onPressed: () {
                      clearFunction();
                    },
                    child: const Center(
                      child: Text(
                        "CLEAR",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Focus(
                autofocus: true,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.1))
                      ]),
                  child: RawMaterialButton(
                    onPressed: () {
                      TextEditingController textController =
                          TextEditingController();
                      if (visibleOutlets.isNotEmpty) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AddBeatDialogBox(
                                  textController,
                                  rangeIndexes,
                                  blueIndexes,
                                  visibleOutlets,
                                  setTempRedRadius);
                            });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                duration: Duration(milliseconds: 500),
                                content: Text("Please select outlet")));
                      }
                    },
                    child: const Center(
                      child: Text(
                        "ADD",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
