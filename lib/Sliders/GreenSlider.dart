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
  final Function refresh;
  final Function emptyNearbyOutlets;
  final Function addBeat;

  GreenSlider(this.clearFunction, this.focusedOutlets, this.visibleOutlets, this.rangeIndexes, this.blueIndexes, this.setTempRedRadius, this.refresh, this.emptyNearbyOutlets, this.addBeat);

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
            "${focusedOutlets.length.toString()} outlets in ${visibleOutlets.length} selected",
            style: const TextStyle(fontSize: 20),
          ),
          SizedBox(height: 12,),
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
                      emptyNearbyOutlets();
                      TextEditingController textController =
                          TextEditingController();
                      if (focusedOutlets.isNotEmpty) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AddBeatDialogBox(
                                  textController,
                                  rangeIndexes,
                                  blueIndexes,
                                  focusedOutlets,
                                  refresh, addBeat);
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
