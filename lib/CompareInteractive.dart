import 'package:flutter/material.dart';

import 'backend/Entities/Outlet.dart';

class CompareInteractive extends StatelessWidget {
  final List<Outlet> outlets;

  const CompareInteractive(this.outlets);

  @override
  Widget build(BuildContext context) {
    double heightOfScreen = MediaQuery.of(context).size.height;
    double widthOfScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: outlets.length == 4
          ? Wrap(
              children: outlets
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: (heightOfScreen - 48) / 2,
                        width: (widthOfScreen - 48) / 2,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: InteractiveImage(),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            )
          : ListView(
              scrollDirection: Axis.horizontal,
              children: outlets
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: heightOfScreen,
                        width: widthOfScreen / 2,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: InteractiveImage(),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class InteractiveImage extends StatelessWidget {
  const InteractiveImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
