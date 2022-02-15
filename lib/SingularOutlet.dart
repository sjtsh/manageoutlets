import 'package:flutter/material.dart';

import 'backend/Entities/Outlet.dart';
import 'backend/database.dart';

class SingularOutlet extends StatelessWidget {
  final Outlet? chosenOutlet;
  final Outlet selectedOutlet;
  final Function setChosenOutlet;

  SingularOutlet(this.selectedOutlet, this.setChosenOutlet,
      {this.chosenOutlet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: () {
          setChosenOutlet(selectedOutlet);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: selectedOutlet == chosenOutlet
                    ? Colors.green
                    : Colors.white,
                width: selectedOutlet == chosenOutlet ? 5 : 0),
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
              Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Checkbox(
                      activeColor: Colors.green,
                      value: selectedOutlet == chosenOutlet,
                      onChanged: (newValue) => setChosenOutlet(selectedOutlet)),
                ],
              ),
              Expanded(
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: Image.network(
                    selectedOutlet.videoName == null
                        ? selectedOutlet.imageURL
                        : localhost + selectedOutlet.imageURL,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
