import 'package:flutter/material.dart';

import '../../DialogBox/renameBeatNameDialog.dart';
import '../../backend/Entities/Distributor.dart';
import '../../backend/Entities/OutletsListEntity.dart';
import '../../backend/Entities/User.dart';
import '../../backend/database.dart';

class AssignedBeat extends StatelessWidget {
  final Beat beat;
  final Function changeColor;
  final int index;
  final Function renameBeat;
  final Function removeBeat;
  final List<User> users;
  final List<Distributor> distributors;

  AssignedBeat(this.beat, this.changeColor, this.index, this.renameBeat,
      this.removeBeat, this.users, this.distributors);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 12),
      child: GestureDetector(
      onTap: (){

        showDialog(
            context: context,
            builder: (_) {
              return RenameBeatNameDialog(
                  beat, renameBeat, distributors);
            });
      },
        child: SizedBox(
          width: 400,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
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
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${beat.outlet.where((element) =>  !element.deactivated).toList().length} Outlets, ${users.firstWhere((e)=> beat.userID == e.id).name}",
                        style: TextStyle(color: Colors.black.withOpacity(0.5)),
                        overflow: TextOverflow.ellipsis,
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
                      changeColor(value, beat.id);
                      // refresh();
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
      ),
    );
  }
}
