import 'dart:async';

import 'package:flutter/material.dart';

import 'backend/database.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int percentage = 0;
  int total = 400;
  int estimatedTime = 4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: estimatedTime)).then((value) {
      setState(() {
        percentage += 10;
      });
      Future.delayed(Duration(seconds: estimatedTime)).then((value) {
        setState(() {
          percentage += 10;
        });
        Future.delayed(Duration(seconds: estimatedTime)).then((value) {
          setState(() {
            percentage += 10;
          });
          Future.delayed(Duration(seconds: estimatedTime)).then((value) {
            setState(() {
              percentage += 10;
            });
            Future.delayed(Duration(seconds: estimatedTime)).then((value) {
              setState(() {
                percentage += 10;
              });

              Future.delayed(Duration(seconds: estimatedTime)).then((value) {
                setState(() {
                  percentage += 10;
                });

                Future.delayed(Duration(seconds: estimatedTime)).then((value) {
                  setState(() {
                    percentage += 10;
                  });

                  Future.delayed(Duration(seconds: estimatedTime))
                      .then((value) {
                    setState(() {
                      percentage += 10;
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logo1,
              width: 300,
              height: 320,
            ),
            Stack(
              children: [
                Container(
                  color: Colors.blueGrey,
                  height: 5,
                  width: total + 0.0,
                ),
                Container(
                  color: Color(0xff00929E),
                  height: 5,
                  width: total * (percentage / 100),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Powered by Hilife",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
