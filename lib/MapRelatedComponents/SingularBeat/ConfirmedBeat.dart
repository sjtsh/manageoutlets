import 'package:flutter/material.dart';

import '../../backend/Entities/OutletsListEntity.dart';
import '../../backend/Entities/User.dart';
import '../../backend/database.dart';

class ConfirmedBeat extends StatelessWidget {
  final Beat beat;
  final Function changeColor;
  final int index;
  final Function renameBeat;
  final Function removeBeat;
  final List<User> users;

  ConfirmedBeat(this.beat, this.changeColor, this.index, this.renameBeat,
      this.removeBeat, this.users);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 12),
      child: SizedBox(
        width: 400,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 2),
                    spreadRadius: 2,
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.1))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(beat.beatName.toString(),
                        style: const TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${beat.outlet.length} Outlets, ${users.firstWhere((e)=> beat.userID == e.id).name}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
                Expanded(child: Container()),
                PopupMenuButton(
                  itemBuilder: (context) {
                    return List.generate(
                        colorIndex.length,
                        (index) => PopupMenuItem(
                              child: Center(
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorIndex[index],
                                      border: Border.all(color: Colors.black)),
                                ),
                              ),
                              value: colorIndex[index],
                            ));
                  },
                  initialValue: beat.color,
                  onSelected: (Color value) {
                    changeColor(value, index, isConfirmed: true);
                    // widget.refresh();
                  },
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: beat.color,
                        border: Border.all(color: Colors.black)),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
