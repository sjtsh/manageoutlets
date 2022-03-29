import 'package:flutter/material.dart';

class BackButtonAlert extends StatefulWidget {
  final String message;
  final String GreyMesage;
  final String RedMessage;
  final Function todo;

  BackButtonAlert(this.message, this.GreyMesage, this.RedMessage, this.todo);

  @override
  State<BackButtonAlert> createState() => _BackButtonAlertState();
}

class _BackButtonAlertState extends State<BackButtonAlert> {
  bool isDisabled = false;

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
                    widget.message,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Are you sure?",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isDisabled
                            ? MaterialButton(
                                onPressed: () async {},
                                color: Colors.red,
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white,),
                                ))
                            : MaterialButton(
                                onPressed: () async {
                                  isDisabled = true;
                                  setState(() {});
                                  try{
                                    await widget.todo();
                                  }catch(e){

                                  }
                                  isDisabled = false;
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                color: Colors.red,
                                child: Text(
                                  widget.GreyMesage,
                                  style: TextStyle(color: Colors.white),
                                )),
                        MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              widget.RedMessage,
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
