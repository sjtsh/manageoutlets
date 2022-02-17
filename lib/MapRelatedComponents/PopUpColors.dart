import 'package:flutter/material.dart';

import '../backend/database.dart';

class PopUpColor extends StatelessWidget {
  final Function changeColor;
  final Color color;

  PopUpColor(this.changeColor, this.color);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return List.generate(
            colorIndex.length,
            (index) => PopupMenuItem(
                  child: Center(
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorIndex[index],
                          border: Border.all(color: Colors.black)),
                    ),
                  ),
                ));
      },
      onSelected: (value) {
        changeColor(value);
      },
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.black)),
      ),
      tooltip: "Show colors",
    );
  }
}
