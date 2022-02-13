import 'package:flutter/material.dart';
import 'package:manage_outlets/backend/database.dart';

import 'GetOutletScreen.dart';

class LocalHostScreen extends StatelessWidget {
  LocalHostScreen({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 200,
              child: TextField(
                controller: controller,
              ),
            ),
            GestureDetector(
              onTap: () {
                if(controller.text!=""){
                  localhost = controller.text;
                }
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return GetOutletScreen(1000000);
                }));
              },
              child: Container(
                height: 100,
                width: 200,
                child: Text("LOG IN")
              ),
            ),
          ],
        ),
      ),
    );
  }
}