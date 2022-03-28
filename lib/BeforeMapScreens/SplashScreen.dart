import 'dart:async';

import 'package:flutter/material.dart';

import '../backend/database.dart';

class SplashScreen extends StatefulWidget {
  final String localhostText;

  SplashScreen(this.localhostText);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int percentage = 0;
  int total = 400;
  int estimatedTime = 10;
  String loadingText = "Loading beats...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future
        .delayed(Duration(seconds: estimatedTime))
        .then((value) {
      if (mounted) {
        setState(() {
          percentage += 10;
          loadingText = "Loading Distributors...";
        });
        Future.delayed(Duration(seconds: estimatedTime)).then((value) {
          if (mounted) {
            setState(() {
              percentage += 10;
              loadingText = "Loading Categories...";
            });
            Future.delayed(Duration(seconds: estimatedTime)).then((value) {
              if (mounted) {
                setState(() {
                  percentage += 10;
                  loadingText = "Loading PathPoint...";
                });
                Future.delayed(Duration(seconds: estimatedTime)).then((value) {
                  if (mounted) {
                    setState(() {
                      percentage += 10;
                      loadingText = "Loading user...";
                    });
                    Future.delayed(Duration(seconds: estimatedTime)).then((
                        value) {
                      if (mounted) {
                        setState(() {
                          percentage += 10;
                          loadingText = "Fetching outlets...";
                        });

                        Future.delayed(Duration(seconds: estimatedTime))
                            .then((value) {
                          if (mounted) {
                            setState(() {
                              percentage += 10;
                              loadingText = "Compiling Outlets...";
                            });

                            Future.delayed(Duration(seconds: estimatedTime))
                                .then((value) {
                              if (mounted) {
                                setState(() {
                                  percentage += 10;
                                  loadingText = "Analyzing Outlets...";
                                });

                                Future.delayed(
                                    Duration(seconds: estimatedTime))
                                    .then((value) {
                                  if (mounted) {
                                    setState(() {
                                      percentage += 10;
                                      loadingText = "Completing...";
                                    });
                                  }
                                });
                              }
                            });
                          }
                        });
                      }
                    });
                  }
                });
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
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
                    height: 10,
                  ),    Text(
                    loadingText,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            "Powered by Hilife",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
            SizedBox(
            height: 10,
    ),
          Text("Trying to run on " + widget.localhostText,
            style: TextStyle(color: Colors.black.withOpacity(0.5)),),
          SizedBox(height: 12,),
        ],
      ),
    );
  }
}