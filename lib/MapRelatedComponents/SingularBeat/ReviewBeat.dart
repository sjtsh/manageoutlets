import 'package:flutter/material.dart';

import '../../DialogBox/renameBeatNameDialog.dart';
import '../../OutletGridViewScreens/NextScreen.dart';
import '../../backend/Entities/Category.dart';
import '../../backend/Entities/Distributor.dart';
import '../../backend/Entities/OutletsListEntity.dart';
import '../../backend/Entities/User.dart';
import '../../backend/database.dart';

class ReviewBeat extends StatelessWidget {
  final Beat beat;
  final Function changeColor;
  final int index;
  final Function renameBeat;
  final List<Category> categories;
  final Function refresh;
  final List<User> users;
  final Distributor dropdownSelectedItem;
  final Function setNewBeats;
  final List<Distributor> distributors;

  ReviewBeat(
      this.beat,
      this.changeColor,
      this.index,
      this.renameBeat,
      this.categories,
      this.refresh,
      this.users,
      this.dropdownSelectedItem,
      this.setNewBeats, this.distributors);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 12),
      child: GestureDetector(
        onDoubleTap: () {
          if (dropdownSelectedItem.id != -1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return NextScreen(beat, categories, refresh,
                  dropdownSelectedItem, setNewBeats);
            }));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please select a distributor"),
              ),
            );
          }
        },
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return RenameBeatNameDialog(beat, renameBeat, distributors);
              });
        },
        child: SizedBox(
          width: 400,
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xffceb108),
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

                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(beat.beatName.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${beat.outlet.where((element) => !element.deactivated).toList().length } Outlets, ${users.firstWhere((e)=> beat.userID == e.id).name}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),),
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
                                        border:
                                            Border.all(color: Colors.black)),
                                  ),
                                ),
                                value: colorIndex[index],
                              ));
                    },
                    initialValue: beat.color,
                    onSelected: (Color value) {
                      changeColor(value, beat,);
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
