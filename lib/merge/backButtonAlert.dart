import 'package:flutter/material.dart';

class BackButtonAlert extends StatelessWidget {
  const BackButtonAlert({Key? key}) : super(key: key);

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
                  const Text(
                    "Your progress will not be saved",
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
                            child: const Text(
                              "Confirm",
                              style: TextStyle(color: Colors.white),
                            )),
                        MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Cancel",
                            ))
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
