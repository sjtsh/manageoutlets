import 'package:flutter/material.dart';

class BlueSlider extends StatefulWidget {
  final removePositions;
  final redRemoveDistance;
  final removePermPositions;
  final Function setRemoveRedRadius;
  final Function setRemovePermPositions;

  BlueSlider(
      this.removePositions,
      this.redRemoveDistance,
      this.removePermPositions,
      this.setRemoveRedRadius,
      this.setRemovePermPositions);

  @override
  State<BlueSlider> createState() => _BlueSliderState();
}

class _BlueSliderState extends State<BlueSlider> {
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
            "${widget.removePositions.length.toString()} outlets found in ${widget.redRemoveDistance.toStringAsFixed(2)}m",
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
                    activeColor: Colors.green,
                    inactiveColor: Colors.green.withOpacity(0.5),
                    thumbColor: Colors.green,
                    value: widget.redRemoveDistance,
                    max: 1000,
                    min: 0,
                    label: "${widget.redRemoveDistance.toStringAsFixed(2)}",
                    onChanged: (double a) {
                      widget.setRemoveRedRadius(a);
                    }),
              ),
              const Text("1000 m"),
              const SizedBox(
                width: 12,
              ),
              const SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: () {
                  widget.setRemovePermPositions([
                    ...widget.removePermPositions,
                    ...widget.removePositions
                  ]);
                },
                child: Container(
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
                  child: const Center(
                    child: Text(
                      "Remove",
                      style: TextStyle(color: Colors.white),
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
