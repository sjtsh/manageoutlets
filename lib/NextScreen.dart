import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class NextScreen extends StatefulWidget {
  static const int _count = 4;

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  final List<bool> _checks = List.generate(NextScreen._count, (_) => false);
  String value = 'A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Select Photo",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        toolbarHeight: 50,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: GridView.builder(
        itemCount: NextScreen._count,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        padding: const EdgeInsets.all(12),
        itemBuilder: (_, i) {
          return Stack(
            children: [
              Image.asset("assets/hilife.jpg"),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.all(8),
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    // value: value,
                    isExpanded: true,
                    hint: value == null
                        ? Text(
                            " Category",
                            style: TextStyle(color: Colors.white),
                          )
                        : Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                    iconEnabledColor: Colors.white,
                    underline: Container(),
                    items: <String>['A', 'B', 'C', 'D'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        value = newValue!;
                      });
                    },
                    // onChanged: (_){},
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Checkbox(
                  activeColor: Colors.blue,
                  value: _checks[i],
                  onChanged: (newValue) =>
                      setState(() => _checks[i] = newValue!),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
