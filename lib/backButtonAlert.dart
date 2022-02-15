import 'package:flutter/material.dart';

class BackButtonAlert extends StatelessWidget {
  final String message;
  final String GreyMesage;
  final String RedMessage;
  final Function todo;

  BackButtonAlert(this.message, this.GreyMesage, this.RedMessage, this.todo);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
              height: 100,
              width: 300,
              child: Column(
                children: [
                  Text(
                    message,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Are you sure to go back?",
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            color: Colors.red,
                            child: Text(
                              GreyMesage,
                              style: TextStyle(color: Colors.white),
                            )),
                        MaterialButton(
                          onPressed: () {
                          todo();
                          },
                          child: Text(
                            "Cancel",
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
