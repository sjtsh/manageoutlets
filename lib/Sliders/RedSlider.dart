import 'package:flutter/material.dart';

import '../DialogBox/addBeatNameDialog.dart';

class RedSlider extends StatelessWidget {
  final redPositions;
  final redDistance;
  final Function setTempRedRadius;
  final rangeIndexes;
  final blueIndexes;
  final Function clearFunction;

  RedSlider(this.redPositions, this.redDistance, this.setTempRedRadius,
      this.rangeIndexes, this.blueIndexes, this.clearFunction);

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
            "${redPositions.length.toString()} outlets found in ${redDistance.toStringAsFixed(2)}m",
            style: const TextStyle(fontSize: 20),
          ),
          Row(
            children: [
              SizedBox(
                width: 12,
              ),
              const Text("0 m"),
              Expanded(
                child: Slider(
                    activeColor: Colors.red,
                    inactiveColor: Colors.red.withOpacity(0.5),
                    thumbColor: Colors.red,
                    value: redDistance,
                    max: 2000,
                    min: 0,
                    label: "${redDistance.toStringAsFixed(2)}",
                    onChanged: (double a) {
                      setTempRedRadius(a);
                    }),
              ),
              const Text("2000 m"),
              const SizedBox(
                width: 12,
              ),
              Container(
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
                      if (redPositions.length != 0) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AddBeatDialogBox(
                                  textController,
                                  rangeIndexes,
                                  blueIndexes,
                                  redPositions,
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
