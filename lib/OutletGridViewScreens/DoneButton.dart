import 'package:flutter/material.dart';


class DoneButton extends StatelessWidget {
  final void Function() doneFunction;

  DoneButton(this.doneFunction);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: doneFunction,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green,
            width: 2,
          ),
        ),
        child: Material(
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "DONE",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_forward_outlined,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
