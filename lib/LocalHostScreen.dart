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
            Expanded(child: Container()),
            Image.asset(
              logo1,
              width: 300,
              height: 320,
            ),
            Container(
              height: 50,
              width: 200,
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 8),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 200,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Color(0xff00929E),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.1))
                  ]),
              child: Material(
                color: Color(0xff00929E),
                child: InkWell(
                  onTap: () {
                    if (controller.text != "") {
                      localhost = controller.text;
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return GetOutletScreen(1000000);
                    }));
                  },
                  child: Center(
                    child: Text(
                      "LOG IN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
