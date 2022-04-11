import 'package:flutter/material.dart';

import '../../BeforeMapScreens/GetOutletScreen.dart';
import '../../DialogBox/backButtonAlert.dart';
import '../../DialogBox/renameBeatNameDialog.dart';
import '../../backend/Entities/Distributor.dart';
import '../../backend/Entities/OutletsListEntity.dart';
import '../../backend/Entities/User.dart';
import '../../backend/Services/BeatService.dart';
import '../../backend/database.dart';

class AssignedBeat extends StatelessWidget {
  final Beat beat;
  final Function changeColor;
  final int index;
  final Function renameBeat;
  final List<User> users;
  final List<Distributor> distributors;
  final Distributor distributor;
  final Function setNewBeats;

  AssignedBeat(this.beat, this.changeColor, this.index, this.renameBeat,
      this.users, this.distributors, this.distributor, this.setNewBeats);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 12),
      child: GestureDetector(
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

                  Expanded(child: Column(
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
                        "${beat.outlet.where((element) => !element.deactivated).toList().length} Outlets, ${users.firstWhere((e) => beat.userID == e.id).name}",
                        style: TextStyle(color: Colors.black.withOpacity(0.5)),
                        overflow: TextOverflow.ellipsis,
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
                      changeColor(value, beat);
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
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return BackButtonAlert(
                                "Do you want to delete this beat?",
                                "Delete",
                                "Cancel", () async {
                              await BeatService()
                                  .deleteBeat(beat.id, distributor,
                                      setNewBeats, context)
                                  .then((value) {
                                if (value == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "${beat.beatName} : Beat deleted Successfully")));
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>
                                      GetOutletScreen(10000000000),));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Failed to delete beat ${beat.beatName}")));
                                }
                              });
                            });
                          });
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Center(
                            child: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 12,
                        )),
                      ),
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
