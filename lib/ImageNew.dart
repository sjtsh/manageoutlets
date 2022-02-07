import 'dart:io';

import 'package:flutter/material.dart';

import 'backend/Outlet.dart';

class ImageNew extends StatefulWidget {
  final List<Outlet> outlets;
  final int indexa;
  final List<int> selected;
  final Function select;

  ImageNew(this.outlets, this.indexa, this.selected, this.select);

  @override
  State<ImageNew> createState() => _ImageNewState();
}

class _ImageNewState extends State<ImageNew> {
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.indexa;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (index > 0) {
                  index--;
                }
              });
            },
            child: Container(
              width: 60,
              color: index > 0 ? Colors.blue :Colors.blueGrey,
              child: Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Builder(builder: (_) {
                          try {
                            return Image.network(
                                widget.outlets[index].imageURL);
                          } catch (e) {
                            return Center(
                              child: Text(e.toString()),
                            );
                          }
                        }),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: Colors.blueGrey,
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Center(
                              child: Text(
                                "Back",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.select(index);
                          setState(() {
                            index++;
                          });
                        },
                        child: Container(
                          color: !widget.selected.contains(index)
                              ? Colors.green
                              : Colors.red,
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Center(
                              child: Text(
                                "Select",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (index < (widget.outlets.length - 1)) {
                  index++;
                }
              });
            },
            child: Container(
              width: 60,
              color: index < (widget.outlets.length - 1) ? Colors.blue :Colors.blueGrey,
              child: Center(
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
